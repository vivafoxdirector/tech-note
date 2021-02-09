package com.skt.mate.admin.controller.survey;


import java.io.File;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.skt.mate.admin.common.code.CodeConst;
import com.skt.mate.admin.common.excel.DownloadXlsStreamSurveyApporvalTarget;
import com.skt.mate.admin.common.excel.DownloadXlsView;
import com.skt.mate.admin.common.excel.DownloadXlsViewOfSurveyAndCouponResult;
import com.skt.mate.admin.common.excel.ExcelModel;
import com.skt.mate.admin.common.excel.MakeXlsOfSurvey;
import com.skt.mate.admin.common.utils.CommonUtils;
import com.skt.mate.admin.common.utils.FileUtil;
import com.skt.mate.admin.config.annotation.AdminAction;
import com.skt.mate.admin.service.messageManage.MateService;
import com.skt.mate.admin.service.survey.SurveyMgmtService;
import com.skt.mate.common.code.CommonCode;
import com.skt.mate.common.code.CommonConst;
import com.skt.mate.common.code.SurveyCode;
import com.skt.mate.common.exception.MateCtrlException;
import com.skt.mate.common.utils.MateDateUtils;
import com.skt.mate.common.utils.StringFormateUtils;
import com.skt.mate.common.utils.pagination.PageBoundsHolder;
import com.skt.mate.common.utils.pagination.PageList;
import com.skt.mate.common.utils.pagination.Pagination;
import com.skt.mate.common.utils.pagination.PaginatorUtil;
import com.skt.mate.model.domain.common.CodeVO;
import com.skt.mate.model.domain.survey.AnsVO;
import com.skt.mate.model.domain.survey.QustVO;
import com.skt.mate.model.domain.survey.SurveyResultVO;
import com.skt.mate.model.domain.survey.SurveyVO;
import com.skt.mate.model.domain.user.AdminUserVO;
import com.skt.mate.model.domain.user.CustomUserVO;
import com.skt.mate.model.domain.user.DealerUserVO;
import com.skt.mate.model.domain.user.Role;
import com.skt.mate.service.CommonCodeService;

@Controller
@RequestMapping("/survey")
public class SurveyController {

    private Logger logger = LoggerFactory.getLogger(getClass());

    @Autowired
    private CommonCodeService commonCodeService;

    @Autowired
    private SurveyMgmtService surveyMgmtService;

    @Autowired
    private MateService mateService;

    @Autowired
    private Properties properties;

    private String datePattern = CommonConst.DISPLAY_DATE_PATTERN_YYYYMMDD;

    @Pagination
    @RequestMapping(value={"reqlist"}, method = {RequestMethod.GET, RequestMethod.POST})
    public String getSurveyReqlist(HttpServletRequest request, Model model
            , @RequestParam(value="isNew" , required=false, defaultValue="true") Boolean isNew
            , @RequestParam(value="isShow" , required=false, defaultValue="true") Boolean isShow
            , @ModelAttribute("searchForm") SurveyVO searchForm) throws Exception {

        //중계사에 따른 고객사 리스트 가져오기
        AdminUserVO loginUser = (AdminUserVO) SecurityContextHolder.getContext().getAuthentication().getDetails();
        
        CustomUserVO cv = new CustomUserVO();

        if(loginUser.getMgmtTp() != null){
            searchForm.setRlcId(loginUser.getRlcId());
            searchForm.setDlcId(loginUser.getDlcId());
            searchForm.setMgmtTp(loginUser.getMgmtTp());
            isShow = false;
        }
        cv.setRlcId(searchForm.getRlcId());
        cv.setDlcId(searchForm.getDlcId());
        cv.setMgmtTp(searchForm.getMgmtTp());

        PageList<CustomUserVO> customList =  mateService.searchCustomUserPageList(cv);
        model.addAttribute("customList", customList);

        List<DealerUserVO> dealList = mateService.selectDealerListByRlcId(searchForm.getRlcId());
        model.addAttribute("dealList", dealList);

        if(isNew){
            searchForm.setSurveyStateCd("REQ_ALL");

            List<Integer> userIdList = new ArrayList<Integer>();

            for(CustomUserVO vo : customList){
                userIdList.add(vo.getUserId());
            }
            Integer[] userIds = new Integer[userIdList.size()];
            userIds = userIdList.toArray(userIds);
            searchForm.setCustomIdList(userIds);
        }

        // 고객사 선택값이 없을 경우
        if(searchForm.getCustomIdList() == null){
            Integer[] userIds = new Integer[]{-1};
            searchForm.setCustomIdList(userIds);
        }

        String today = MateDateUtils.getCurrentDateString(datePattern);
        model.addAttribute("today", today);

        if(StringUtils.isEmpty(searchForm.getSearchStartDate())
                || StringUtils.isEmpty(searchForm.getSearchEndDate())){

            searchForm.setSearchStartDate(MateDateUtils.getCurrentDateString(CommonConst.DISPLAY_DATE_PATTERN_YYYYMM) + "-01");
            searchForm.setSearchEndDate(today);
        }

        PageList<SurveyVO> pageList = null;
        PaginatorUtil paginatorUtil = PageBoundsHolder.getPaginatorUtil();

        int minRowNum = paginatorUtil.getMinRowNum();
        int maxRowNum = paginatorUtil.getMaxRowNum();

        searchForm.setMinRowNum(minRowNum);
        searchForm.setMaxRowNum(maxRowNum);
        
        if(StringUtils.isEmpty(searchForm.getOrd1())){
        	searchForm.setOrd1("DESC");
        }
        
        pageList = surveyMgmtService.searchSurveyRequestList(searchForm, paginatorUtil);

        int totalCnt = 0;
        int pageCnt = 1;

        if(pageList != null){
            PaginatorUtil paginatorUtilByList = pageList.getPaginator();

            totalCnt = paginatorUtilByList.getTotalCount();
            pageCnt = totalCnt - ( (paginatorUtilByList.getPage() - 1) * paginatorUtilByList.getLimit() );
        }

        model.addAttribute("totalCnt", totalCnt);
        model.addAttribute("pageCnt", pageCnt);
        model.addAttribute("list", pageList);
        model.addAttribute("paramVO", searchForm);
        model.addAttribute("isNew", isNew);
        model.addAttribute("isShow", isShow);

        model.addAttribute("hiddenParamters", CommonUtils.getHiddenHtmlTagByParameters(request));

        return "survey/surveyReqList";
    }
    @RequestMapping(value={"approve"}, method = {RequestMethod.GET, RequestMethod.POST})
    public String approveSurvey(HttpServletRequest request, Model model
            , @ModelAttribute("searchForm") SurveyVO searchForm) throws Exception {


        return "survey/surveyReqList";
    }

    @RequestMapping(value={"contentDownload"}, method = {RequestMethod.GET, RequestMethod.POST})
    public void downloadSurvey(HttpServletResponse response, Model model
            , @ModelAttribute("searchForm") SurveyVO searchForm) throws Exception {


        String rootPath = properties.getProperty("file.save.root.path");
        String surveyPath = properties.getProperty("admin.file.survey.path");
        SurveyVO surveyInfo = surveyMgmtService.getSurveyInfo(searchForm);
        List<QustVO> questList = surveyMgmtService.getSurveyQuestionListById(surveyInfo.getSurveySeq());

        List<Long> qustSeq = new ArrayList<>();
        List<Long> couponSeq = new ArrayList<>();
        for(QustVO qustVo : questList){
            qustSeq.add(qustVo.getQustSeq());
            if(qustVo.getQustFormCd().equals(SurveyCode.QustFormCd.COUPON.name())){
                couponSeq.add(qustVo.getQustSeq());
            }
        }
        List<AnsVO> answerList = surveyMgmtService.getSurveyAnswerListByQustId(qustSeq);

        List<CodeVO> formCodeList = commonCodeService.searchCodeListByCdGrpId("QUST_FORM_CD");

        Map<String, String> formMap = new HashMap<>();
        for(CodeVO code : formCodeList){
            formMap.put(code.getCdId(), code.getCdNm());
        }

        List<CodeVO> orderCodeList = commonCodeService.searchCodeListByCdGrpId("QUST_ORD_CL_CD");

        Map<String, String> orderMap = new HashMap<>();
        for(CodeVO code : orderCodeList){
            orderMap.put(code.getCdId(), code.getCdNm());
        }

        List<CodeVO> resCodeList = commonCodeService.searchCodeListByCdGrpId("QUST_RES_CL_CD");

        Map<String, String> resMap = new HashMap<>();
        for(CodeVO code : resCodeList){
            resMap.put(code.getCdId(), code.getCdNm());
        }

        String fileNm = "survey_"+new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA).format(new Date())+".xlsx";

        List<String> fields = new ArrayList<String>();
        fields.add("질문");
        fields.add("문항 형식");
        fields.add("선택지 옵션");
        fields.add("응답 옵션");
        fields.add("질문 내용");
        fields.add("응답 시");
        fields.add("이미지");
        fields.add("스크린아웃 메시지");

        ExcelModel excelModel = new ExcelModel(fileNm, fields);
        List<Map<String, String>> couponExcelList = new ArrayList<Map<String, String>>();

        excelModel.addAttribute("surveyInfo", surveyInfo);

        List<String> imgList = new ArrayList<String>();

        //설문동의 안내메시지 이미지 경로
        if(surveyInfo.getSurveyAgreImgFilePath() != null){
            imgList.add(rootPath + surveyInfo.getSurveyAgreImgFilePath());
        }

        //설문완료 안내메시지 이미지 경로
        if(surveyInfo.getSurveyComplImgFilePath() != null){
            imgList.add(rootPath + surveyInfo.getSurveyComplImgFilePath());
        }

        for(QustVO vo : questList){
            String imgUrl="";
            if(vo.getQustImgUrl() != null) {
                imgUrl = vo.getQustImgUrl();
                imgList.add(rootPath + imgUrl);
                imgUrl = imgUrl.substring(imgUrl.lastIndexOf("/")+1);
            }

            if(vo.getQustFormCd().equals(SurveyCode.QustFormCd.MLTPC.name())){//객관식
                excelModel.addRowData(Arrays.asList(
                        "질문"+vo.getQustPrtOrd()
                        ,formMap.get(vo.getQustFormCd())
                        ,orderMap.get(vo.getQustOrdClCd())
                        ,resMap.get(vo.getQustResClCd())
                        ,vo.getQustCont()
                        ,""
                        ,imgUrl
                        ,""
                ));
                for(AnsVO ansVO : answerList){
                    String surveyComplGuideMsg = "";
                    if(ansVO.getQustSeq().equals(vo.getQustSeq())){
                        String nextSeqStr = "다음 문항으로 진행";
                        if (ansVO.getNextQustSeq() != null) {
                            if(qustSeq.indexOf(ansVO.getNextQustSeq()) >= (qustSeq.size() - couponSeq.size())){
                                nextSeqStr = "쿠폰 " + (couponSeq.indexOf(ansVO.getNextQustSeq()) + 1);
                            }else if (qustSeq.indexOf(ansVO.getNextQustSeq()) - qustSeq.indexOf(ansVO.getQustSeq()) > 1) {
                                nextSeqStr = "질문 " + (vo.getQustPrtOrd() + qustSeq.indexOf(ansVO.getNextQustSeq()) - qustSeq.indexOf(ansVO.getQustSeq()));
                            } else if (ansVO.getAnsPrtOrd() == 0) {
                                nextSeqStr = "질문 1";
                            }
                        }else if (ansVO.getNextQustSeq() == null) {
                            if (null != ansVO.getCouponTotRcvYn() && ansVO.getCouponTotRcvYn().equals("Y")) {
                                nextSeqStr = "모든 쿠폰 발행";
                            } else if (ansVO.getSurveyComplGuideMsg() == null) {
                                nextSeqStr = "설문 완료";
                            } else {
                                nextSeqStr = "스크린아웃";
                                surveyComplGuideMsg = ansVO.getSurveyComplGuideMsg();
                            }
                        }

                        excelModel.addRowData(Arrays.asList(
                                ""
                                ,""
                                ,""
                                ,ansVO.getAnsPrtOrd()
                                ,ansVO.getAnsCont()
                                ,nextSeqStr
                                ,""
                                ,surveyComplGuideMsg
                        ));
                    }
                }
            }else if(vo.getQustFormCd().equals(SurveyCode.QustFormCd.COUPON.name())){//쿠폰
                String nextSeqStr = "다음 문항으로 진행";
                for(AnsVO ansVO : answerList){
                    if(ansVO.getQustSeq().equals(vo.getQustSeq())){
                        if(ansVO.getNextQustStepYn().equals("N")){
                            if(ansVO.getNextQustSeq() == null){
                                nextSeqStr = "설문 완료";
                            }else{
                                nextSeqStr = "질문 " + (qustSeq.indexOf(ansVO.getNextQustSeq()) + 1);
                            }
                        }

                        Map<String, String> couponExcelMap = new HashMap<String, String>();
                        couponExcelMap.put("columnTitle", "쿠폰" + (vo.getQustPrtOrd() + couponSeq.size() - qustSeq.size()) + " 메시지 제목");
                        couponExcelMap.put("title", vo.getCouponTitleMsg());
                        couponExcelMap.put("columnNext", "쿠폰 발행 시");
                        couponExcelMap.put("next", nextSeqStr);
                        couponExcelMap.put("columnImg", "이미지");
                        couponExcelMap.put("img", imgUrl);
                        couponExcelMap.put("columnMsg", "쿠폰" + (vo.getQustPrtOrd() + couponSeq.size() - qustSeq.size()) + " 메시지");
                        if(null == vo.getCouponCdFileUrl()){
                            couponExcelMap.put("msg", vo.getQustCont());
                        }else{
                            couponExcelMap.put("msg", "쿠폰번호 : 793asf341\n" + vo.getQustCont());
                        }

                        couponExcelList.add(couponExcelMap);
                    }
                }
            }else{//주관식
                String nextSeqStr = "다음 문항으로 진행";
                String surveyComplGuideMsg = "";
                for(AnsVO ansVO : answerList){
                    if(ansVO.getQustSeq().equals(vo.getQustSeq())){
                        if (ansVO.getNextQustSeq() != null) {
                            if(qustSeq.indexOf(ansVO.getNextQustSeq()) >= (qustSeq.size() - couponSeq.size())){
                                nextSeqStr = "쿠폰 " + (couponSeq.indexOf(ansVO.getNextQustSeq()) + 1);
                            }else if (qustSeq.indexOf(ansVO.getNextQustSeq()) - qustSeq.indexOf(ansVO.getQustSeq()) > 1) {
                                nextSeqStr = "질문 " + (vo.getQustPrtOrd() + qustSeq.indexOf(ansVO.getNextQustSeq()) - qustSeq.indexOf(ansVO.getQustSeq()));
                            }
                        }else if (ansVO.getNextQustSeq() == null) {
                            if (null != ansVO.getCouponTotRcvYn() && ansVO.getCouponTotRcvYn().equals("Y")) {
                                nextSeqStr = "모든 쿠폰 발행";
                            } else {
                                nextSeqStr = "설문 완료";
                            }
                        }

                        excelModel.addRowData(Arrays.asList(
                                "질문"+vo.getQustPrtOrd()
                                ,formMap.get(vo.getQustFormCd())
                                ,""
                                ,resMap.get(vo.getQustResClCd())
                                ,vo.getQustCont()
                                ,nextSeqStr
                                ,imgUrl
                                ,surveyComplGuideMsg
                        ));
                    }
                }
            }

            if(!vo.getQustFormCd().equals(SurveyCode.QustFormCd.COUPON.name())) {//쿠폰
                excelModel.addRowData(Arrays.asList(
                        "답변 오류 알림 메시지"
                        ,""
                        ,""
                        ,""
                        ,vo.getAnsErrNotiMsg()
                        ,""
                        ,""
                        ,""
                ));
                excelModel.addRowData(Arrays.asList(
                        ""
                ));
            }
        }

        excelModel.addAttribute("couponExcelList", couponExcelList);

        String filePath = rootPath+surveyPath+ File.separator+surveyInfo.getCustomId()+File.separator+surveyInfo.getSurveySeq()+"/zip";
        MakeXlsOfSurvey ms = new MakeXlsOfSurvey(excelModel, filePath);

        String zipNm = "survey_" + new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA).format(new Date()) + ".zip";

        if(!StringUtils.isEmpty(filePath)){
            String zipPath = filePath + File.separator + zipNm;
            String excelPath = filePath + File.separator + fileNm;
            try {
                if(FileUtil.makeZip(filePath, zipNm, imgList)){
                    FileUtil.downloadFile(response, zipPath, zipNm);

                    // 생성한 zip파일 삭제
                    File zipFile = new File(zipPath);
                    boolean del = zipFile.delete();
                    if(del){
                        logger.info("[" + zipPath + "] delete success images download complete !!!");
                    }else{
                        logger.warn("[" + zipPath + "] delete fail ... !!!");
                    }
                }else{
                    logger.info("not images");
                }
                File excel = new File(excelPath);
                boolean excelDel = excel.delete();
                if(excelDel){
                    logger.info("[" + excelPath + "] delete success excel download complete !!!");
                }else{
                    logger.warn("[" + excelPath + "] excel delete fail ... !!!");
                }
            } catch (IOException ex) {
                logger.info("Error writing file to output stream. Filename was '{}'", zipPath, ex);
                throw new MateCtrlException("IOError writing file to output stream");
            }
        }else{
            throw new MateCtrlException("[file_path] is null !!");
        }
    }

    @Pagination
    @RequestMapping(value={"list"}, method = {RequestMethod.GET, RequestMethod.POST})
    public String getSurveyList(HttpServletRequest request, Model model
            , @RequestParam(value="isNew" , required=false, defaultValue="true") Boolean isNew
            , @RequestParam(value="isShow" , required=false, defaultValue="true") Boolean isShow
            , @ModelAttribute("searchForm") SurveyVO searchForm) throws Exception {

        //중계사에 따른 고객사 리스트 가져오기
        AdminUserVO loginUser = (AdminUserVO) SecurityContextHolder.getContext().getAuthentication().getDetails();

        CustomUserVO cv = new CustomUserVO();

        if(loginUser.getMgmtTp() != null){
            searchForm.setRlcId(loginUser.getRlcId());
            searchForm.setDlcId(loginUser.getDlcId());
            searchForm.setMgmtTp(loginUser.getMgmtTp());
            isShow = false;
        }
        cv.setRlcId(searchForm.getRlcId());
        cv.setDlcId(searchForm.getDlcId());
        cv.setMgmtTp(searchForm.getMgmtTp());

        PageList<CustomUserVO> customList =  mateService.searchCustomUserPageList(cv);
        model.addAttribute("customList", customList);

        List<DealerUserVO> dealList = mateService.selectDealerListByRlcId(searchForm.getRlcId());
        model.addAttribute("dealList", dealList);

        if(isNew){
            searchForm.setSurveyStateCd("LIST_ALL");
            searchForm.setSearchType("startDay");
            List<Integer> userIdList = new ArrayList<Integer>();

            for(CustomUserVO vo : customList){
                userIdList.add(vo.getUserId());
            }
            Integer[] userIds = new Integer[userIdList.size()];
            userIds = userIdList.toArray(userIds);
            searchForm.setCustomIdList(userIds);
        }

        // 고객사 선택값이 없을 경우
        if(searchForm.getCustomIdList() == null){
            Integer[] userIds = new Integer[]{-1};
            searchForm.setCustomIdList(userIds);
        }

        String today = MateDateUtils.getCurrentDateString(datePattern);
        model.addAttribute("today", today);

        if(StringUtils.isEmpty(searchForm.getSearchStartDate())
                || StringUtils.isEmpty(searchForm.getSearchEndDate())){

            searchForm.setSearchStartDate(MateDateUtils.getCurrentDateString(CommonConst.DISPLAY_DATE_PATTERN_YYYYMM) + "-01");
            searchForm.setSearchEndDate(today);
        }


        PageList<SurveyVO> pageList = null;
        PaginatorUtil paginatorUtil = PageBoundsHolder.getPaginatorUtil();

        int minRowNum = paginatorUtil.getMinRowNum();
        int maxRowNum = paginatorUtil.getMaxRowNum();

        searchForm.setMinRowNum(minRowNum);
        searchForm.setMaxRowNum(maxRowNum);
        
        if(StringUtils.isEmpty(searchForm.getOrd1())){
        	searchForm.setOrd1("DESC");
        }

        pageList = surveyMgmtService.searchSurveyRequestList(searchForm, paginatorUtil);

        int totalCnt = 0;
        int pageCnt = 1;

        if(pageList != null){
            PaginatorUtil paginatorUtilByList = pageList.getPaginator();

            totalCnt = paginatorUtilByList.getTotalCount();
            pageCnt = totalCnt - ( (paginatorUtilByList.getPage() - 1) * paginatorUtilByList.getLimit() );
        }

        model.addAttribute("totalCnt", totalCnt);
        model.addAttribute("pageCnt", pageCnt);
        model.addAttribute("list", pageList);

        model.addAttribute("loginId", loginUser.getUserId());
        model.addAttribute("isNew", isNew);
        model.addAttribute("isShow", isShow);
        model.addAttribute("paramVO", searchForm);
        model.addAttribute("hiddenParamters", CommonUtils.getHiddenHtmlTagByParameters(request));

        return "survey/surveyList";
    }


    @AdminAction(target="CUST", action="R")
    @RequestMapping(value={"calculateCount"}, method={RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public Map<String, Object> calculateCount(HttpServletRequest request, HttpSession session
            ,ModelMap model
            , @RequestParam(value="isFirst" , required=false, defaultValue="true") Boolean isFirst
            ,@ModelAttribute("searchForm") SurveyVO searchForm) throws Exception {

        AdminUserVO adminUser = (AdminUserVO)SecurityContextHolder.getContext().getAuthentication().getDetails();

        logger.info("[excelUpload] SurveyController.calculateCount has called");
        searchForm.setCrtUserId(adminUser.getUserId()+"");
        try {
        	Map<String, Object> surveyMap = surveyMgmtService.saveTargetingFile(searchForm, session);
        	return surveyMap;
        }finally {
        	session.removeAttribute(CodeConst.SURVEY_SAVE_TOT_PROGRESS);
        	session.removeAttribute(CodeConst.SURVEY_SAVE_COMPL_PROGRESS);
            logger.info("[excelUpload] SurveyController.calculateCount has returned");

		}
    }
    
    @AdminAction(target="CUST", action="R")
    @RequestMapping(value={"checkSurveyCalculateProgress"}, method={RequestMethod.GET})
    @ResponseBody
    public Map<String, Object> checkSurveyCalculateProgress(HttpSession session) {
    	Map<String, Object> resultMap = new HashMap<>();
    	
        logger.info("[excelUpload] SurveyController.checkSurveyCalculateProgress has called");

    	resultMap.put(CodeConst.SURVEY_SAVE_TOT_PROGRESS, session.getAttribute(CodeConst.SURVEY_SAVE_TOT_PROGRESS) == null ? 0 : session.getAttribute(CodeConst.SURVEY_SAVE_TOT_PROGRESS));
    	resultMap.put(CodeConst.SURVEY_SAVE_COMPL_PROGRESS, session.getAttribute(CodeConst.SURVEY_SAVE_COMPL_PROGRESS) == null ? 0 : session.getAttribute(CodeConst.SURVEY_SAVE_COMPL_PROGRESS));
        logger.info("totProgressCnt : {}, cmplProgressCnt : {}", (int)resultMap.get(CodeConst.SURVEY_SAVE_TOT_PROGRESS), (int)resultMap.get(CodeConst.SURVEY_SAVE_COMPL_PROGRESS));
    	logger.info("[excelUpload] SurveyController.checkSurveyCalculateProgress has returned");

    	return resultMap;
    }
    
    
    @AdminAction(target="CUST", action="R")
    @RequestMapping(value={"updateState"}, method={RequestMethod.GET, RequestMethod.POST})
    @ResponseBody
    public Map<String, Object> updateState(HttpServletRequest request
            ,ModelMap model
            ,@ModelAttribute("searchForm") SurveyVO searchForm) throws Exception {
        AdminUserVO adminUser = (AdminUserVO)SecurityContextHolder.getContext().getAuthentication().getDetails();

        logger.info(">>> updateState : surveySeq={}", searchForm.getSurveySeq());

        Map<String, Object> surveyMap = new HashMap<>();

        try {
        	surveyMap = surveyMgmtService.updateSurveyState(searchForm, adminUser);
        }catch (Exception e){
            surveyMap.put("resCd", "fail");
        }
        return surveyMap;

    }

    @RequestMapping(value={"surveyResult"}, method = {RequestMethod.POST})
    @ResponseBody
    public ModelAndView getSurveyResult(HttpServletRequest request, Model model
            , @ModelAttribute("searchForm") SurveyVO searchForm) throws Exception {

        // 1. 해당 설문이 있는지 체크
        // 3. 해당 설문 상태가 종료(왼료 또는 취소) 되었는지 체크
        AdminUserVO user = (AdminUserVO)SecurityContextHolder.getContext().getAuthentication().getDetails();

        List<Role> roleList = (List<Role>)user.getAuthorities();

        SurveyVO survey = surveyMgmtService.selectSurveyInfo(searchForm.getSurveySeq());
        
        boolean isMasking = true;
        if(roleList.get(0).getRoleTpCd().equals(CommonCode.AdminRoleTpCd.ADM.name())
        	&& StringUtils.equals("Y", survey.getTgtCndUseYn())){
            isMasking = false;
        }

        //1. 해당 설문이 있는지 체크
        if(survey == null){
            throw new MateCtrlException("해당 설문 정보가 없음");
        }

        //2. 데이터 조회
        // 설문문항 목록 
        List<QustVO> qustList = surveyMgmtService.getSurveyQuestionListById(searchForm.getSurveySeq());
        
        //설문결과(쿠폰포함)-정상답변
        //List<SurveyResultVO> surveyResultList = surveyMgmtService.getSurveyResultListById(searchForm);
        searchForm.setNormalAnsYn("Y");
        List<SurveyResultVO> surveyAndCouponNormalAnswerResultList = surveyMgmtService.selectSurveyAndCouponResultList(searchForm);
        //설문결과(쿠폰포함)-비정상답변
        searchForm.setNormalAnsYn("N");
        List<SurveyResultVO> surveyAndCouponNotNormalAnswerResultList = surveyMgmtService.selectSurveyResultExcelList(searchForm);
        //문항수
        int questionCount = surveyMgmtService.selectSurveyQuestionCount(searchForm.getSurveySeq());
        //쿠폰수
        int couponCount = surveyMgmtService.selectSurveyCouponCount(searchForm.getSurveySeq());
        
        //발송 대상자수
        int sendTargetCount = surveyMgmtService.selectSendTargetCount(searchForm.getSurveySeq());
        //중복체크로 Drop 된 수
        int duplicatedDropCount = surveyMgmtService.selectDuplicatedDropCount(searchForm.getSurveySeq());
        //발송 시도자 수
        int trySendTargetCount = surveyMgmtService.selectTrySendTargetCount(searchForm.getSurveySeq());
        //인트로 메세지 수신자 수
        int receivedIntroMessageCount = surveyMgmtService.selectReceivedIntroMessageCount(searchForm.getSurveySeq());
        //인트로 메세지 미수신자 수
        int notReceivedIntroMessageCount = trySendTargetCount - receivedIntroMessageCount;
        
        //최초 질문 수신자 수
        int receivedFirstQuestionCount = surveyMgmtService.selectReceivedFirstQuestionCount(searchForm.getSurveySeq());
        
        //오류 발생자 수 (설문안내 메시지 미수신자 수 + 최초질문 미수신자 수)
        int errorCount = notReceivedIntroMessageCount ;
        if(questionCount > 0) {
        	errorCount += (receivedIntroMessageCount - receivedFirstQuestionCount);
        }
        
        //MO 응답자 수
        int sendMoCount = surveyMgmtService.selectSendMoCount(searchForm.getSurveySeq());
        //유효 응답자 수
        int sendEffectiveMoCount = surveyMgmtService.selectSendEffectiveMoCount(searchForm.getSurveySeq());
        //MO 비정상 응답자 수
        int sendNotNormalMoCount = sendMoCount - sendEffectiveMoCount;
        //스크린 아웃 수
        int screenOutCount = surveyMgmtService.selectScreenOutCount(searchForm.getSurveySeq());
        //Reward 수신자 수
        int receivedRewardCount = surveyMgmtService.selectReceivedRewardCount(searchForm.getSurveySeq());
        //설문 완료자 수
        int surveyCompletedCount = surveyMgmtService.selectSurveyCompletedCount(searchForm.getSurveySeq());
        //설문 미완료자 수
        // int surveyNotCompletedCount = sendEffectiveMoCount - surveyCompletedCount;
        int surveyNotCompletedCount = sendEffectiveMoCount - (surveyCompletedCount + screenOutCount);
        if (surveyNotCompletedCount < 0)	surveyNotCompletedCount = 0;
        //Reward MMS/LMS 전송시간
        String sendRewardTermInfo = surveyMgmtService.selectSendRewardTermInfo(searchForm.getSurveySeq());
        
        String excelDownNm = "설문결과";
        String fileNm = CommonUtils.getExcelDownloadFmByBrowser(request, excelDownNm) + "_" + new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA).format(new Date())+".xlsx";

        List<String> fields = new ArrayList<String>();
        ExcelModel excelModel = new ExcelModel(fileNm, fields);
        
        excelModel.addAttribute("isMasking",								isMasking);
        excelModel.addAttribute("surveyInfo",								survey);
        excelModel.addAttribute("questionCount",							questionCount);
        excelModel.addAttribute("couponCount",								couponCount);
        excelModel.addAttribute("qustList",									qustList);
        excelModel.addAttribute("surveyAndCouponNormalAnswerResultList",	surveyAndCouponNormalAnswerResultList);
        excelModel.addAttribute("surveyAndCouponNotNormalAnswerResultList",	surveyAndCouponNotNormalAnswerResultList);
        excelModel.addAttribute("sendTargetCount",							sendTargetCount);
        excelModel.addAttribute("duplicatedDropCount",						duplicatedDropCount);
        excelModel.addAttribute("trySendTargetCount",						trySendTargetCount);
        excelModel.addAttribute("receivedIntroMessageCount",				receivedIntroMessageCount);
        excelModel.addAttribute("notReceivedIntroMessageCount",				notReceivedIntroMessageCount);
        excelModel.addAttribute("errorCount",								errorCount);
        excelModel.addAttribute("receivedFirstQuestionCount",				receivedFirstQuestionCount);
        excelModel.addAttribute("sendMoCount",								sendMoCount);
        excelModel.addAttribute("sendNotNormalMoCount",						sendNotNormalMoCount);
        excelModel.addAttribute("screenOutCount",							screenOutCount);
        excelModel.addAttribute("surveyNotCompletedCount",					surveyNotCompletedCount);
        excelModel.addAttribute("receivedRewardCount",						receivedRewardCount);
        excelModel.addAttribute("surveyCompletedCount",						surveyCompletedCount);
        excelModel.addAttribute("sendRewardTermInfo",						sendRewardTermInfo);
        
        //공통코드맵핑S
        List<CodeVO> surveyStateCdList = commonCodeService.searchCodeListByCdGrpId("SURVEY_STATE_CD");

        Map<String, String> surveyStateCdMap = new HashMap<>();
        
        for(CodeVO code : surveyStateCdList){
        	surveyStateCdMap.put(code.getCdId(), code.getCdNm());
        }
        
        excelModel.addAttribute("surveyStateCdMap", surveyStateCdMap);
        //공통코드맵핑E

        ModelAndView modelAndView = new ModelAndView(new DownloadXlsViewOfSurveyAndCouponResult());
        modelAndView.addObject("excelModel", excelModel);
        
        return modelAndView;
    }
    
    @RequestMapping(value={"{pathId}/downloadExcel"}, method = {RequestMethod.GET, RequestMethod.POST})
    @Pagination
    public ModelAndView getSurveyExcel(HttpServletRequest request, Model model
            ,@PathVariable("pathId") String pathId
            , @RequestParam(value="isNew" , required=false, defaultValue="true") Boolean isNew
            , @ModelAttribute SurveyVO searchForm) throws Exception {

        ModelAndView modelAndView = null;

        AdminUserVO adminUser = (AdminUserVO)SecurityContextHolder.getContext().getAuthentication().getDetails();

        String userId = String.valueOf(adminUser.getUserId());

        HashMap<String, String> resultMap = new HashMap<String, String>();
        String resCd = "success";

        boolean isShow = true;
        if(adminUser.getMgmtTp() != null){
            searchForm.setRlcId(adminUser.getRlcId());
            searchForm.setDlcId(adminUser.getDlcId());
            searchForm.setMgmtTp(adminUser.getMgmtTp());
            isShow = false;
        }
        searchForm.setUpdUserId(userId);

        if(isNew){
            CustomUserVO cv = new CustomUserVO();
            cv.setMgmtTp(searchForm.getMgmtTp());
            cv.setRlcId(searchForm.getRlcId());
            cv.setDlcId(searchForm.getDlcId());
            PageList<CustomUserVO> customList =  mateService.searchCustomUserPageList(cv);

            List<Integer> userIdList = new ArrayList<Integer>();
            for(CustomUserVO vo : customList){
                userIdList.add(vo.getUserId());
            }
            Integer[] userIds = new Integer[userIdList.size()];
            userIds = userIdList.toArray(userIds);
            searchForm.setCustomIdList(userIds);
        }
        List<CodeVO> targetCodeList = commonCodeService.searchCodeListByCdGrpId("SURVEY_TARGET_YN_CD");
        List<CodeVO> stateCodeList = commonCodeService.searchCodeListByCdGrpId("SURVEY_STATE_CD");

        Map<String, String> targetMap = new HashMap<>();
        for(CodeVO code : targetCodeList){
            targetMap.put(code.getCdId(), code.getCdNm());
        }
        Map<String, String> stateCodeMap = new HashMap<>();
        for(CodeVO code : stateCodeList){
            stateCodeMap.put(code.getCdId(), code.getCdNm());
        }
        if(StringUtils.isEmpty(searchForm.getSearchStartDate())
                || StringUtils.isEmpty(searchForm.getSearchEndDate())){

            searchForm.setSearchStartDate(MateDateUtils.getCurrentDateString(CommonConst.DISPLAY_DATE_PATTERN_YYYYMM) + "-01");
            String today = MateDateUtils.getCurrentDateString(datePattern);
            searchForm.setSearchEndDate(today);
        }

        int totalCount = surveyMgmtService.getSurveyTotalCount(searchForm);

        searchForm.setMinRowNum(0);
        searchForm.setMaxRowNum(totalCount);

        List<SurveyVO> surveyList =surveyMgmtService.getSurveyRequestList(searchForm);

        String fileNm = "survey_"+new SimpleDateFormat("yyyyMMddHHmmss", Locale.KOREA).format(new Date())+".xlsx";

        List<String> fields = new ArrayList<String>();
        fields.add("No");
        if(isShow){
            fields.add("중계사");
            fields.add("딜러사");
        }
        fields.add("고객사명");
        fields.add("설문 유형");
        fields.add("MDN 지정 쿠폰");
        fields.add("메시지 유형");
        fields.add("제목");
        fields.add("상태");
        fields.add("수동대사");
        fields.add("발송 목표 건수");
        fields.add("정산 건수");
        fields.add("신청일시");
        fields.add("시작일시");
        fields.add("종료일시");
        fields.add("신청 ID");

        if("list".equals(pathId)){
            fields.add("처리 ID");
        }


        ExcelModel excelModel = new ExcelModel(fileNm, fields);

        int totalCnt = surveyList.size();
        for (SurveyVO vo : surveyList) {
            List<String> values1 = new ArrayList<String>();

            values1.add(totalCnt-- + "");

            if(isShow){
                values1.add(vo.getRlcNm());
                values1.add(StringUtils.defaultString(vo.getDlcNm(), ""));
            }
            values1.add(StringUtils.defaultString(CommonUtils.toReverseXss(vo.getCustomNm()), ""));
            values1.add(targetMap.get(vo.getTgtCndUseYn()));
            String assignYn = "";
            if("N".equals(vo.getAgreCouponAssignYn())) {
            	assignYn = "-";
            }else {
            	assignYn = "O";
            }
            values1.add(assignYn);
            
            String surveyMsgTp = "-";
            if(null != vo.getSurveyMsgTp() || "".equals(vo.getSurveyMsgTp())) {
            	surveyMsgTp = vo.getSurveyMsgTp();
            }
            
            values1.add(surveyMsgTp);
            values1.add(vo.getSurveyTitle());
            values1.add(stateCodeMap.get(vo.getSurveyStateCd()));
            
            String bookingYn = "";
            if(null != vo.getBookingYn() || "".equals(vo.getBookingYn())) {
            	if("M".equals(vo.getBookingYn())) {
            		bookingYn = "O";
            	}else {
            		bookingYn = "-";
            	}
            }else {
            	bookingYn = "-";
            }
            values1.add(bookingYn);
            
            DecimalFormat df = new DecimalFormat("#,###");
            String surveyComlTargetCnt = df.format(vo.getSurveyComplTargetCnt());
            values1.add(surveyComlTargetCnt);
            
            String balanceAccountCnt = df.format(vo.getBalanceAccountCnt());
            values1.add(balanceAccountCnt);
            values1.add(MateDateUtils.getDateToString(vo.getCrtDttm(), "yyyy-MM-dd HH:mm"));
            values1.add(vo.getSurveyStartStr());
            values1.add(vo.getSurveyEndStr());
            values1.add(StringFormateUtils.toMaskId(vo.getLoginId()));

            if("list".equals(pathId)) {
                values1.add(StringFormateUtils.toMaskId(vo.getApprUserNm()));
            }

            excelModel.addRowData(values1);
        }

        return new ModelAndView(new DownloadXlsView(), "excelModel", excelModel);
    }

    @RequestMapping(value={"sndTestSurvey"}, method={RequestMethod.POST})
    @ResponseBody
    public Map<String, String> sndTestSurvey(HttpServletRequest request, ModelMap model,
                                             @ModelAttribute SurveyVO surveyVO){

        AdminUserVO loginUser = (AdminUserVO) SecurityContextHolder.getContext().getAuthentication().getDetails();

        Map<String, String> resultMap = new HashMap<String, String>();

        String resCd = "success";

        surveyMgmtService.saveTestSurvey(surveyVO, loginUser);

        resultMap.put("resCd",resCd);

        return resultMap;
    }
    
    @RequestMapping(value={"downloadAppExcel"})
    public ModelAndView downloadAppExcel(HttpServletRequest request, Model model
            , @RequestParam(value="surveySeq" , required=true) Long surveySeq
            , @RequestParam(value="excelRcverPhoneNumCnt" , required=true) Integer excelRcverPhoneNumCnt
            , @RequestParam(value="dupPhoneNumCnt" , required=true) Integer dupPhoneNumCnt
            , @RequestParam(value="errorPhoneNumCnt" , required=true) Integer errorPhoneNumCnt
            ) throws Exception {
    	
    	logger.info("surveySeq : {}, excelRcverPhoneNumCnt : {}, dupPhoneNumCnt : {}, errorPhoneNumCnt : {}"
    			, surveySeq, excelRcverPhoneNumCnt, dupPhoneNumCnt, errorPhoneNumCnt);
    	
    	SurveyVO survey = surveyMgmtService.searchSurveyTgtAppInfoExcel(surveySeq);
    	List<SurveyVO> dupSurveyList = surveyMgmtService.searchSurveyTgtAppDupNumExcel(surveySeq);
    	
    	Map<String, Object> map = new HashMap<String, Object>();
    	map.put("survey", survey);
    	map.put("dupSurveyList", dupSurveyList);
    	map.put("excelRcverPhoneNumCnt", excelRcverPhoneNumCnt);
    	map.put("dupPhoneNumCnt", dupPhoneNumCnt);
    	map.put("errorPhoneNumCnt", errorPhoneNumCnt);
    	
    	
    	return new ModelAndView(new DownloadXlsStreamSurveyApporvalTarget(), "excelModel", map);
    }
}