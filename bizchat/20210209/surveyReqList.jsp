<!DOCTYPE html>
<jsp:directive.page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"/>
<jsp:directive.include file="/WEB-INF/views/common/common.jsp"/>
<html>
<head>
    <title>설문 승인</title>
    <script type="text/javascript">
        //<![CDATA[
        "use strict";

        var objLayerShift = {shiftLeft:-300, shiftTop:-103};
        var isProcessingAlertDisp = false;

        var isFirst = true;//승인 엑셀파일 처음으로 올리는 경우
        $(document).ajaxStart(function() {
            if(isProcessingAlertDisp){
                $("#popProcessingDiv").showByCenter();
            }

            $("#_bgPrgss").heightOfWindowHeight();
            $("#_bgPrgss").widthOfWindowWidth();
            $("#_bgPrgss").show();
            //$("#_bgPrgss").attr("tabindex", "-1").focus();
            $( document.activeElement ).blur();
        });

        $(document).ajaxComplete(function() {
            $("#popProcessingDiv").hide();
            $("#_bgPrgss").hide();
            isProcessingAlertDisp = false;
        });

        $( document ).ajaxError(function( event, request, settings ) {
            if(request.status == 403) {
                alert("처리 권한이 없는 요청입니다.");
            } else if(request.status == 404) {
                alert("존재하지 않는 기능 요청입니다.");
            } else if(request.status == 500) {
                alert("처리 중 500 오류가 발생하였습니다.");
            } else if(request.status == 999) { // 시스템정의
                alert("장시간 서버와 통신이 없어 회원정보 보호를 위해 자동으로 로그아웃 되었습니다.");
                location.href = "/";
            }
            else {
                alert("처리 중 "+request.status+" 오류가 발생하였습니다.");
            }
        });
        $.ajaxSetup({
            beforeSend: function(xhrObj) {
                xhrObj.setRequestHeader("Accept","application/json");
            }
        });

        var INSERT_CONFIRM_ALERT = "등록하시겠습니까?";
        var SAVE_CONFIRM_ALERT = "저장하시겠습니까?";
        var DEL_CONFIRM_ALERT = "삭제하시겠습니까?";


        $(window).on("resize", function () {
            $(".feePopup").centerWhenShowed();
            $(".popup").centerWhenShowed();
            $("#popProcessingDiv").centerWhenShowed();

            if($("#popBg").css("display") == 'block'){
                $("#popBg").heightOfWindowHeight();
                $("#popBg").widthOfWindowWidth();
            }

            if($("#_bgPrgss").css("display") == 'block'){
                $("#_bgPrgss").heightOfWindowHeight();
                $("#_bgPrgss").widthOfWindowWidth();
            }
        });

        $(document).ready(function(){
            $(document).bind("contextmenu", function(e) {
                return false;
            });

            checkSpace();
            projectIdCheck();
        });

        //영문,숫자만 입력
        function projectIdCheck(){
            $(".projectid-check").keyup(function (event) {
                var text = $(this).val();
                $(this).val(text.replace(/[^a-z0-9]/gi,''));
            });
        }

        function checkSpace() {
            $(".space-check").keyup(function () {
                var text = $(this).val();
                if (isSpace(text)) {
                    $(this).val(text.replace(/ /g, ''));
                }
            });
        }

        function isSpace(str) {
            if(str.search(/\s/) != -1) {
                return true;
            } else {
                return false;
            }
        }

        $(document).bind('selectstart',function() {return false;});
        $(document).bind('dragstart',function(){return false;});

        $(document).mousedown(function(){if ((event.button==2) || (event.button==2)){alert("개인정보 보호를 위해 마우스 우클릭은 금지되었습니다.");return false;}});
        //]]>
    </script>

    <style type="text/css">
        #popCustomList{width: 350px;}
        .txt_center { font-size: 14px; text-align: center; line-height: 20px; padding: 10px 20px; }
        .survey-approve-pop1 {
            width: 350px;}
        .survey-approve-pop2,.survey-approve-pop3{
            width: 350px;
        }
    </style>
    <script type="text/javascript">

        var baseUrl = "/svMate";
        var totalCustCnt = ${fn:length(customList)};

        $(document).ready(function(){

            $('#lebelsndMdn').data('placeholder', $('#lebelsndMdn').attr('placeholder'))
                .focus(function() {
                    $(this).attr('placeholder', '');
                })
                .blur(function() {
                    $(this).attr('placeholder', $(this).data('placeholder'));
                });


            $('#lebelrcvMdn').data('placeholder', $('#lebelrcvMdn').attr('placeholder'))
                .focus(function() {
                    $(this).attr('placeholder', '');
                })
                .blur(function() {
                    $(this).attr('placeholder', $(this).data('placeholder'));
                });

            // 숫자만 입력
            $('.number_only').css("ime-mode", "disabled").keydown( function(e) {
                numberValChk.keyDown(e);
            }).keyup( function(e){
                numberValChk.keyUp(e);
            }).change( function(e){
                numberValChk.focusOut($(this));
            });

            $("#btnSubmit").click(function(){
                $('input[name=isNew]').attr('value',"false");
                $("#searchForm").submit();
            });

           /* $("#excelBtn").click(function(){

                if(${totalCnt} > excelLimit){
                    alert("${alertExcelLimit}");
                    return false;
                }

                if(${isNew}){
                    $('#otherForm input[name=surveyStateCd]').remove();
                    $('#otherForm').append('<input type="hidden" name="surveyStateCd" value="REQ_ALL" />');
                }
                $("#otherForm #surveySeq").remove();
                $("#otherForm").attr("action","<c:url value='/survey/reqlist/downloadExcel'/>");
                $("#otherForm").submit();

            });*/

            // 팝업 x버튼
            $(".feePopup .top button").on("click", function () {
                $("#btnCancel").click();
                return false;
            });

            /*$(".survey-approve-pop .cancelBtn").on("click", function () {
                $(".survey-approve-pop").hideBg().hide();
            });*/

            $("#btnCancel").click(function(){

                if(!confirm("취소하시겠습니까?")){
                    return false;
                }

                // 클릭시 체크 박스 초기화
                $("#popCustomList input[id^='searchCustomArr_']").prop("checked",false);
                var selCustIds = $("#selCustId").val().split(",");
                for(var i = 0; i < selCustIds.length; i++){
                    var selCustId = selCustIds[i];

                    if(selCustId != ""){
                        $("#popCustomList input[id='searchCustomArr_" + selCustId + "']").prop("checked",true);
                    }
                }

                if(selCustIds.length == totalCustCnt){
                    $("#checkall").prop("checked",true);
                }else{
                    $("#checkall").prop("checked", false);
                }

                $(".contract_list button").focus();
                setPopupInfo();
            });

            $("#btnPopSave").click(function(){
                var ckval = $('#searchForm input:checkbox[name=customIdList]:checked').length;

                var selCustId = "";
                $('#searchForm input:checkbox[name=customIdList]:checked').each(function(){
                    selCustId = selCustId + ","+$(this).val();
                });

                if(selCustId.indexOf(",") > -1){
                    selCustId = selCustId.substring(1);
                }
                $("#selCustId").val(selCustId);

                var resultHtml = "";
                if(totalCustCnt == ckval){
                    resultHtml = "고객사 전체 선택됨";
                }else{
                    resultHtml = "고객사 "+ckval+"개 선택됨";
                }

                $(".selBody").html(resultHtml);
                
                setPopupInfo();
            });

            $("#checkall").change(function(){
                //클릭되었으면
                if($("#checkall").prop("checked")){
                    //input태그의 name이 chk인 태그들을 찾아서 checked옵션을 true로 정의
                    $("#searchForm input[name=customIdList]").prop("checked",true);
                    //클릭이 안되있으면
                }else{
                    //input태그의 name이 chk인 태그들을 찾아서 checked옵션을 false로 정의
                    $("#searchForm input[name=customIdList]").prop("checked",false);
                }
            });

            $("#searchForm input[name=customIdList]").click(function(){
                var ckval = $('#searchForm input:checkbox[name=customIdList]:checked').length;

                if(totalCustCnt == ckval){
                    $("#checkall").prop("checked", true);
                }else{
                    $("#checkall").prop("checked", false);
                }
            });
            $('#rcverPhoneNumFile').change(function(evt){
            	$('#approve-error-text').hide();
            	$('#targetNumCnt span').html("0");
            	$('#assignedCouponCount span').html("0");
                var fileElement = evt.target;

                if($('#rcverPhoneNumFile').val() == ''){
                    $('#approveBtn').attr('disabled', true);
                    $('#appExcelBtn').attr('disabled', true);                    
                    return;
                }

                var ext = fileElement.value.split(".").pop().toLowerCase();
                if (ext != "xlsx") {
                    $('#approveBtn').attr('disabled', true);
                    $('#appExcelBtn').attr('disabled', true);
                    alert("엑셀 형식만 가능합니다.");
                    return ;
                }

                $('#rcverPhoneNumFile').attr('name',"rcverPhoneNumFile");
                $("#frmApprove").ajaxForm({
                    type : "POST",
                    url : "/survey/calculateCount",
                    enctype: "multipart/form-data",
                    async : true,
                    dataType : "JSON",
                    beforeSubmit: function(){
						startProgressbar();
					}, 
                    success : function(response) {

                        if(response.resCd == 'success'){
                        	
                        	var barProgress = jQuery(".progressbar");
				        	barProgress.find(".progress-label").html("100%");
							barProgress.progressbar({value:100});
                        	
                            $('input[name=isFirst]').attr('value',"false");

                            $('#rcverPhoneNumCnt span').html(response.totalCount);	// 타겟팅 수신자 번호
                            $('#rcverPhoneNumCnt').siblings('input[name=rcverPhoneNumCnt]').val(response.totalCount);
                            
                            $('#rcvRjtPhoneNumCnt span').html(response.rejectCount);	// 수신거부 번호
                            $('#rcvRjtPhoneNumCnt').siblings('input[name=rcvRjtPhoneNumCnt]').val(response.rejectCount);
                            
                            $('#dupPhoneNumCnt span').html(response.dupCount);			// 엑셀 파일 내 중복된 번호
                            $('#dupPhoneNumCnt').siblings('input[name=dupPhoneNumCnt]').val(response.dupCount);
                            
                            $('#dupRunSurveyCnt span').html(response.dupRunCount);		// 진행중인 설문 중복번호
                            $('#dupRunSurveyCnt').siblings('input[name=dupRunSurveyCnt]').val(response.dupRunCount);
                            
                            $('#dupExpectSurveyCnt span').html(response.dupExpectCount);// 진행예정 설문 중복번호
                            $('#dupExpectSurveyCnt').siblings('input[name=dupExpectSurveyCnt]').val(response.dupExpectCount);
                            
                            $('#errorPhoneNumCnt span').html(response.errorCount);		// 유효하지 않은 번호
                            $('#errorPhoneNumCnt').siblings('input[name=errorPhoneNumCnt]').val(response.errorCount);
                            
                            $('#targetNumCnt span').html(response.calCount);			// 발송 대상 수신자 번호
                            $('#targetNumCnt').siblings('input[name=targetNumCnt]').val(response.calCount);
                            
                            $('#assignedCouponCount span').html(response.assignedCouponCount);	// MDN 별로 지정된 쿠폰 업로드 갯수
                            $('#assignedCouponCount').siblings('input[name=assignedCouponCount]').val(response.assignedCouponCount);
                            
                            $('#randomCouponCount span').html(response.randomCouponCount);	// 랜덤쿠폰 갯수
                            $('#randomCouponCount').siblings('input[name=randomCouponCount]').val(response.randomCouponCount);
                            
                            $('#rcverPhoneNumFile').attr('name','');
                            $('#rcverPhoneNumFileUrl').val(response.rcverPath);
                            
                            if(response.calCount > 0){
                            	$('#approveBtn').attr('disabled', false);
                                //$('#appExcelBtn').attr('disabled', false);	
                            } else {
                            	$('#approveBtn').attr('disabled', true);
                                //$('#appExcelBtn').attr('disabled', true);
                            }
                            $('#appExcelBtn').attr('disabled', false);
                            
                            if (response.resMsg == 'couponCodeIsSmall'){
                                $('#approve-error-text').show();
                                $('#approve-error-text span').text('등록된 랜덤쿠폰 개수가 수신자보다 적습니다.');
                            }
                            
                        }else if(response.resCd == 'excelFormatError'){
                            $('#approveBtn').attr('disabled', true);
                            $('#appExcelBtn').attr('disabled', true);
                            alert('엑셀 양식이 올바르지 않습니다.');
                        }else if(response.resCd == 'couponCodeError'){
                            $('#approveBtn').attr('disabled', true);
                            $('#appExcelBtn').attr('disabled', true);
                            alert("MDN 선지정 쿠폰 코드에 " + (response.rcvCount - response.assignedCouponCount) + "건의 포맷 오류가 있습니다.");
                        }
                        
                        else if(response.resCd == 'couponCodeNullError'){
                            $('#approveBtn').attr('disabled', true);
                            $('#appExcelBtn').attr('disabled', true);
                            $('#approve-error-text').show();
                            $('#approve-error-text span').text('MDN 지정 쿠폰 설문입니다. 쿠폰 코드를 입력해주세요.');
                            alert("MDN 지정 쿠폰 설문입니다. 쿠폰 코드를 입력해주세요.");
                        }else if(response.resCd == 'couponCodeNotAssignError'){
                            $('#approveBtn').attr('disabled', true);
                            $('#appExcelBtn').attr('disabled', true);
                            $('#approve-error-text').show();
                            $('#approve-error-text span').text('MDN 지정 쿠폰 등록이 불가능한 설문입니다.');
                            alert("MDN 지정 쿠폰 등록이 불가능한 설문입니다.");
                        }else if(response.resCd == 'couponCodeCompareError'){
                            $('#approveBtn').attr('disabled', true);
                            $('#appExcelBtn').attr('disabled', true);
                            $('#approve-error-text').show();
                            $('#approve-error-text span').text('등록된 MDN 지정 쿠폰 개수가 수신자 보다 적습니다.');
                            alert("등록된 MDN 지정 쿠폰 개수가 수신자 보다 적습니다.");
                        }
                        else{
                            $('#approveBtn').attr('disabled', true);
                            $('#appExcelBtn').attr('disabled', true);
                            alert('데이터가 없습니다.');
                        }
                    },
                    error : function(){

                        $('#approveBtn').attr('disabled', true);
                        $('#appExcelBtn').attr('disabled', true);
                        setTimeout(function() {
                            alert("처리 중 error 오류가 발생하였습니다.");
                        }, 100);
                    },
                    complete : function(){                    	
                    	setTimeout(function() { stopProgressbar(); }, 1000);
                    }
                });
                $("#frmApprove").submit();
            });

            //중계사 선택 이벤트
            $("#rlcId").change(function(){
                doCustomlist($(this).val(), true);
            });
            //딜러사 선택 이벤트
            $("#dlcId").change(function(){
                doCustomlist($(this).val(), false);
            });
            function doCustomlist(selectedId, isRlc) {

                var rlcType = "";
                var param = "";
                if(isRlc){
                    rlcType = "rlc";
                    param = "rlcId="+selectedId;
                }else{
                    rlcType = "dlc";
                    param += "rlcId="+$("#rlcId").val()+"&dlcId="+selectedId;
                }
                param += "&" + encodeURI("${_csrf.parameterName}=${_csrf.token}");
                var url = "/stat/"+rlcType+"/customlist";

                $.ajax({
                    type : "POST",
                    url : url,
                    data : param,
                    async : true,
                    dataType : "JSON",
                    success : function(response) {

                        var customList = response;
                        if(isRlc){
                            customList = response.customList;
                            var dealList = response.dealList;

                            $("#dlcId option[value!='']").remove();
                            $.each(dealList, function(index, obj){
                                $("#dlcId").append("<option value="+obj.dlcId+">"+obj.dlcDPNm+"</option>");
                            });
                        }
                        var contentsCnt = 0;
                        var contents = "";
                        $.each(customList, function(index, obj) {
                            contents += "<p><input id='searchCustomArr_" + (obj.userId) + "' name='customIdList' type='checkbox' value='" + obj.userId + "' style='width:17px;height:17px;'/><label for='searchCustomArr_" + obj.userId + "'>" + obj.userNm + "</label></p>";
                            contentsCnt++;
                        });

                        $("#divUserIdList").html(contents);

                        if(contentsCnt == 0){
                            $("#checkall").prop("checked",false);
                        }else{
                            $("#checkall").prop("checked",true);
                            $("#searchForm input[name=customIdList]").prop("checked",true);
                        }

                        $("#searchForm input:checkbox[name='customIdList']").click(function(){
                            if(!$(this).prop("checked")){
                                if($("#checkall").prop("checked")){
                                    $("#checkall").prop("checked", false);
                                    $("#searchForm input:checkbox[name='customIdList']").prop("checked", false);
                                }
                            }
                        });

                        $("#btnPopSave").click();
                    },
                    error : function(request, status, error ) {
                    }
                });
            }

            $('#rejectBtn').click(function(){
                if($('#reject_ta').val() == ""){
                    $('.error-message').css('display', '');
                    return;
                }
               updateState($('#popSeq').val(), $("#popType").val(), $('#reject_ta').val(), $('#surveySeq').val(), $("#rejectTgtCndUseYn").val());
            });

            $('#approveBtn').click(function(){
            	var confirmCheck = false;
            	if($("#checkingExceptYn").val() == "Y"){
            		if(confirm("정보광고 수신 동의 대사 작업 없이 발송 하시겠습니까?")){
            			confirmCheck = true;
            		}
            	}else{
            		if(confirm("설문을 승인하시겠습니까?")){
            			confirmCheck = true;
            		}
            	}

                if(confirmCheck){
                    $('#rcverPhoneNumFile').attr('name',"rcverPhoneNumFile");
                    $("#frmApprove").ajaxForm({
                        type : "POST",
                        url : "/survey/updateState",
                        enctype: "multipart/form-data",
                        async : true,
                        dataType : "JSON",
                        success : function(response) {
                            if(response.resCd == 'surveyStateError'){
    	                    	$('#approveBtn').attr('disabled', true);
    	                        $('#appExcelBtn').attr('disabled', true);
    	                        var time = "";
    	                        if(response.nextTimeYn == 'Y'){
    	                        	time = "(다음 가장 빠른 발송 시간은 "+ response.nextTime +" 입니다.)";
    	                        }else{
    	                        	time = "(현재 "+ response.nextTime +"까지 등록 가능한 시간이 없습니다.)";
    	                        }
    	                        alert("정보광고 수신 동의 대사 작업 시작 전에만 승인이 가능합니다.\n"+time);
    		                }else if(response.resCd == 'surveyOverError'){
    		                	$('#approveBtn').attr('disabled', true);
    	                        $('#appExcelBtn').attr('disabled', true);
    	                        var time = "";
    	                        if(response.nextTimeYn == 'Y'){
    	                        	time = "(다음 가장 빠른 발송 시간은 "+ response.nextTime +" 입니다.)";
    	                        }else{
    	                        	time = "(현재 "+ response.nextTime +"까지 등록 가능한 시간이 없습니다.)";
    	                        }
    	                        alert("발송 대상자 수가 고객사의 발송 목표 건수 보다 많습니다.\n추가 대사 시간이 필요하여 발송 시간을 변경해야 합니다.\n"+time);
    		                }else{
    		                	$('#rcverPhoneNumFile').attr('name','');
                                $(".survey-approve-pop").hideBg().hide();
    		                	location.href="<c:url value='/survey/reqlist' />?" + $("#searchForm").serialize();
    		                }
                            
                        },
                        error : function(){
                            setTimeout(function() {
                                alert("처리 중 오류가 발생하였습니다.");
                            }, 100);
                            $('#rcverPhoneNumFile').attr('name','');
                        }
                    });
                    $("#frmApprove").submit();

                }
            });
            
            $('#appExcelBtn').click(function(){ 
            	/*
            	var surveySeq = $("#frmApprove").find("input[name=surveySeq]").val();
            	var rcverPhoneNumCnt = $('#rcverPhoneNumCnt').siblings('input[name=rcverPhoneNumCnt]').val();
            	var dupPhoneNumCnt = $('#dupPhoneNumCnt').siblings('input[name=dupPhoneNumCnt]').val();
            	var errorPhoneNumCnt = $('#errorPhoneNumCnt').siblings('input[name=errorPhoneNumCnt]').val();
            	
            	$("#contentDownForm").empty();
            	$("#contentDownForm").attr("action","<c:url value='/survey/downloadAppExcel'/>");
            	$("#contentDownForm").append("<input type='hidden' name='surveySeq' value='"+surveySeq+"'/>");
            	$("#contentDownForm").append("<input type='hidden' name='excelRcverPhoneNumCnt' value='"+rcverPhoneNumCnt+"'/>");
            	$("#contentDownForm").append("<input type='hidden' name='dupPhoneNumCnt' value='"+dupPhoneNumCnt+"'/>");
            	$("#contentDownForm").append("<input type='hidden' name='errorPhoneNumCnt' value='"+errorPhoneNumCnt+"'/>");            	
            	$("#contentDownForm").submit();
            	*/
            	
            	var paramData = {
						svcCl : "SV",
						surveySeq : $("#frmApprove").find("input[name=surveySeq]").val(),
						excelRcverPhoneNumCnt : $('#rcverPhoneNumCnt').siblings('input[name=rcverPhoneNumCnt]').val(),
						dupPhoneNumCnt : $('#dupPhoneNumCnt').siblings('input[name=dupPhoneNumCnt]').val(),
						errorPhoneNumCnt : $('#errorPhoneNumCnt').siblings('input[name=errorPhoneNumCnt]').val(),
						totalCnt : $('#rcverPhoneNumCnt').siblings('input[name=rcverPhoneNumCnt]').val()
				};
            	$("#paramStr").val(JSON.stringify(paramData));
            	
            	var fieldInfo = {
						excelName : "tgtSubject"
				};
				$("#fieldInfo").val(JSON.stringify(fieldInfo));
            	
				$("#appExcelForm").ajaxForm({
                    type : "POST",
                    url : "/svMate/downloadExcel",
                    enctype: "multipart/form-data",
                    async : true,
                    dataType : "JSON",
                    success : function(response) {
                        if(response.resCd == 'success'){
                            alert("다운로드 요청이 완료되었습니다.\n엑셀 파일은'엑셀 다운로드함'에서 확인해 주세요.\n(100만건 요청시 약 7분 소요)");
                        }
                    },
                    error : function(){
                        setTimeout(function() {
                            alert("처리 중 오류가 발생하였습니다.");
                        }, 100);
                    }
                });
				$("#appExcelForm").submit();
            });

            $("#popReason button").on("click", function () {
                $("#popReason").hideBg().hide();
            });
            $("#popApprove .cancelBtn, #popApprove .top .f_r").on("click", function () {
            	if(!confirm("취소하시겠습니까?")){
                    return false;
                }
            	
            	$('#approve-error-text').hide();
                $("#popApprove").hideBg().hide();
            });
            $("#popReject .cancelBtn, #popReject .top .f_r").on("click", function () {
            	if(!confirm("취소하시겠습니까?")){
                    return false;
                }
            	
            	$('#popReject').hideBg().hide();
            });

            checkSearchList();
            init();

            $("#msgTp").css('width','200px');
            $("#errCd").css('width','310px');

            //테스트발송 팝업 취소
            $("#pop-testMsg .cancelBtn, #pop-testMsg .close").on("click", function(){
                $('#pop-testMsg').hideBg().hide();
            });

            //test 발송 - 폰번호 추가
            $("#addCellPhone").click(function () {
                var cellPhone = "";
                $(".cellPhone").each(function (idx,obj) {
                    cellPhone += $(obj).val()+"";
                });

                //폰번호 미입력시
                if(cellPhone.length != 11){
                    alert("테스트 수신번호를 입력해 주세요.");
                    return;
                }

                var testNumCnt = $("#testNumList tr").length;
                if(testNumCnt == 21){
                    alert("테스트 발송은 최대 20명까지 가능합니다.");
                    return;
                }

                $("#noCellPhone").css("display","none");

                var cellPhone1 = $(".cellPhone").eq(0).val();
                var cellPhone2 = $(".cellPhone").eq(1).val();
                var cellPhone3 = $(".cellPhone").eq(2).val();

                var cellPhoneHtml = "<tr class=\"cellPhoneRow\">";
                cellPhoneHtml += "<td class=\"count\">" + testNumCnt + "</td>";
                cellPhoneHtml += "<td>" + cellPhone1 + "-" + cellPhone2 + "-" + cellPhone3 + "</td>";
                cellPhoneHtml += "<td><button type=\"button\" onclick=\"deletePhoneNum(this)\"><img src=\"../inc/img/btn-delete-q-2.png\" alt=\"번호 삭제\"></button>";
                cellPhoneHtml += "<input type=\"hidden\" name=\"rcverList\" value=\"" + cellPhone1 + cellPhone2 + cellPhone3 + "\">";
                cellPhoneHtml += "</td>";
                cellPhoneHtml += "</tr>";

                $("#testNumList").append(cellPhoneHtml);

                $(".cellPhone").each(function (idx,obj) {
                    $(obj).val("");
                });
            });

            //테스트발송
            $("#sndTest").click(function(){
                var sndMdnlist = $(".cellPhoneRow").length;
                if(sndMdnlist < 1){
                    alert("테스트 수신번호를 입력해 주세요.");
                    return;
                }

                if(confirm("테스트 설문을 발송하시겠습니까?")){
                    var data = $("#sndTestForm").serialize();
                    $.ajax({
                        type : "POST",
                        url : "<c:url value='/survey/sndTestSurvey'/>",
                        data : data,
                        enctype: "multipart/form-data",
                        async : true,
                        dataType : "JSON",
                        success : function(response) {
                            if(response.resCd == "success"){
                                location.href = "<c:url value='/survey/reqlist?' />" + $("#paginationForm").serialize();
                            }else if(response.resCd == "already use"){
                                alert(response.spcNum + "특번으로" + response.surveyStartDate+"~"+response.surveyEndDate+" 설문이 진행중입니다.");
                            }else{
                                alert(response.resCd);
                            }
                        },
                        error : function(){
                        }
                    });
                }
            });
            $("#exceptYn").click(function(){
            	if($("input:checkbox[name=exceptYn]").is(":checked") == true) {
                	$("#checkingExceptYn").val("Y");
                }else{
                	$("#checkingExceptYn").val("N");
                }
            });
<<<<<<< HEAD
            
            $(".stat thead th a").on("click", function  () {
                var idx = $(".stat thead th a").index($(this));

                if ($(this).hasClass("on")) {
                    $(this).children().toggleClass("asc");
                    if ($(this).children().hasClass("asc")) $(this).children().text("오름차순");
                    else $(this).children().text("내림차순");

                }
                else $(this).addClass("on").parent().siblings().children().removeClass("on");
				
                if ($(this).children().hasClass("asc")) {

                    if(idx == 0){
                        $("#ord1").val("ASC");
                    }else{
                        $("#ord1").val("");
                    }

                } else {
                    if(idx == 0){
                        $("#ord1").val("DESC");
                    }else{
                        $("#ord1").val("");
                    }
                }
				
                location.href = "<c:url value='/survey/reqlist?' />" + $("#searchForm").serialize();
                
                return false;
            });
            
=======

			$('input[name="sndTest_Msg_type"]').on('click',function(){
				if($('input:radio[name="sndTest_Msg_type"]:checked').val() == "GEN"){
					console.log("테스트 발송 - 일반 선택");
					$("#pop-testMsg #surveyType").val("GEN");
				}else{
					console.log("테스트 발송 - RCS 선택");
					$("#pop-testMsg #surveyType").val("RCS");
				}
			});
			
>>>>>>> feature/BIZCHAT-1070
        });

        function checkSearchList() {

            var searchCustomIds = [
                <c:forEach var="userId" items="${paramVO.customIdList}" varStatus="i">
                ${userId} ${not i.last ? ',':''}
                </c:forEach>
            ];

            var totalCustCnt = ${fn:length(customList)};
            if(totalCustCnt == searchCustomIds.length){
                $("#checkall").prop("checked",true);
                $("#checkall").change();
            }else{
                for(var i=0; i<searchCustomIds.length; i++){
                    $("#searchCustomArr_"+searchCustomIds[i]).prop("checked", true);
                }
            }
            $("#btnPopSave").click();
        }

        function init() {
            if("${searchFromDt}" == "" && "${searchToDt}" == "") {
                $("#caltoday").click();
            }
            if("${paramVO.surveyStateCd}" == ""){
                $('input[name=surveyStateCd][value=REQ_ALL]').attr('checked', 'checked');
            }
        }

        function goCustomerDetail(id) {
            returnPageManager.doNextPage("/customer/detail?userId=" + id +"", "" + baseUrl + "/completeList?" + $("#paginationForm").serialize());
        }

        function showReason(btn) {
        	
        	var surveyTitle = $(btn).parent().parent().find("[survey_title]").html();
        	$('#popReason').find('[name=survey_title]').html(surveyTitle);
        	
            var reason = $(btn).parent().next().html();
            $('#popReason .reason').html(reason);
            $('#popReason').showBg().showByCenter();

        }
        function popApprove(customId, surveyId, targetUserYn, surveySeq, surveyComplTargetCnt, agreCouponAssignYn, tgtCndUseYn, agreCouponCdFileUrl, surveyStateCd, surveyStartStr, bookingYn) {
            if(targetUserYn == 'Y'){//타겟팅
                $('#approveBtn').attr('disabled', 'disabled');
                $('#appExcelBtn').attr('disabled', 'disabled');
                $('#rcverPhoneNumFile').val("");
                //$('#targetCondition').text(targetText);
                $('#targetCondition').text($('td[data-seq-no='+surveyId+']:last ').html());
                $('#rcverPhoneNumCnt span').html('0');
                $('#rcvRjtPhoneNumCnt span').html('0');
                $('#dupPhoneNumCnt span').html('0');                
                $('#dupRunSurveyCnt span').html('0');
                $('#dupExpectSurveyCnt span').html('0');                
                $('#errorPhoneNumCnt span').html('0');
                $('#targetNumCnt span').html('0');
                $('#assignedCouponCount span').html('0');
                $('#randomCouponCount span').html('0');
                $("#surveyComplTargetCnt span").html(surveyComplTargetCnt==0? '-': surveyComplTargetCnt);
                $('#surveyComplTargetCnt').siblings('input[name=surveyComplTargetCnt]').val(surveyComplTargetCnt);
                $("#popCustomId").val(customId);
                $("#popApproveId").val(surveyId);
                $("#popAgreCouponAssignYn").val(agreCouponAssignYn);
                $("#popTgtCndUseYn").val(tgtCndUseYn);
                $("#popAgreCouponCdFileUrl").val(agreCouponCdFileUrl);
                $("#popSurveyStateCd").val(surveyStateCd);
				$("#popSurveyStartStr").val(surveyStartStr);
                $('#popApprove').showBg().showByCenter();
                
                $("#popBookingYn").val(bookingYn);
                if(bookingYn == "M"){
                	$("#popApprove .bookingYn").hide();
                	$("#popApprove .bookingM").show();
                }else{
                	$("#popApprove .bookingYn").show();
                	$("#popApprove .bookingM").hide();
                }

            }else{
                if(confirm("설문을 승인하시겠습니까? \n 발송 목표건수 :" +(surveyComplTargetCnt==0? '-': surveyComplTargetCnt)+ "건")){
                    updateState(surveyId, 'APPR', "", surveySeq, tgtCndUseYn);
                }
            }

        }
        function popReject(id, surveySeq, btn, tgtCndUseYn) {
        	var surveyTitle = $(btn).parent().parent().find("[survey_title]").html();
        	$('#popReject').find('[name=survey_title]').html(surveyTitle);
        	
            $('#popSeq').val(id);
            $('#surveySeq').val(surveySeq);
            $('#popType').val('REJECT');
            $('#reject_ta').val("");
            $('.error-message').css('display', 'none');
            $("#rejectTgtCndUseYn").val(tgtCndUseYn);
            $('#popReject').showBg().showByCenter();
        }

        function setPopupInfo() {
            $(".feePopup").hideBg().hide();
        }

        function contentDownload(id){
            $("#contentDownForm").attr("action","<c:url value='/survey/contentDownload'/>");
            $('#surveySeq').remove();
            $("#contentDownForm").append("<input type='hidden' name='surveySeq' id='surveySeq' value='"+id+"'/>");
            $("#contentDownForm").submit();
        }
        function updateState(surveySeq, surveyStateCd, descr, surveySeq, tgtCndUseYn){
            $.ajax({
                type : "POST",
                url : "<c:url value='/survey/updateState'/>",
                data : {
                    "surveySeq"     : surveySeq,
                    "surveyStateCd" : surveyStateCd,
                    "descr"         : descr,
                    "tgtCndUseYn"   : tgtCndUseYn,
                    "${_csrf.parameterName}" : "${_csrf.token}",
                    "surveySeq" : surveySeq
                },
                async : true,
                dataType : "JSON",
                success : function(response) {
                    $(".survey-approve-pop").hideBg().hide();
                    $("#searchForm").submit();
                    /*location.href="<c:url value='/survey/reqlist' />?" + $("#searchForm").serialize();*/
                },
                error : function(){
                    $(".survey-approve-pop").hideBg().hide();
                }
            });
        }

        //테스트발송 팝업
        function popTestMsg(surveySeq, surveyType){
            //초기화
            $("#noCellPhone").show();
            $(".cellPhoneRow").remove();
            $(".cellPhone").val("");

            //$("#orgSurveySeq").val(surveySeq);
            $("#pop-testMsg #orgSurveySeq").val(surveySeq);
            $("#pop-testMsg #surveyType").val(surveyType);

            $('#pop-testMsg').showBg().showByCenter();
            $('#pop-testMsg').css("left", "0px");

            console.log("popTestMsg : surveySeq = %d  surveyType = %s", surveySeq, surveyType);

            switch (surveyType)
            {
            case "GEN":
            	$("input:radio[name='sndTest_Msg_type']:radio[value='GEN']").prop('checked', true);
            	$("input:radio[name='sndTest_Msg_type']:radio[value='RCS']").prop('checked', false);

            	$("input:radio[name='sndTest_Msg_type']:radio[value='GEN']").prop("disabled", false);
            	$("input:radio[name='sndTest_Msg_type']:radio[value='RCS']").prop("disabled", true);
            	
            	$("input:radio[name='sndTest_Msg_type']:radio[value='GEN']").show();
            	$("input:radio[name='sndTest_Msg_type']:radio[value='RCS']").hide();
            	
            	$('label[for="general"]').show();
            	$('label[for="rcs"]').hide();
            	break;
            
            case "RCS":
            	$("input:radio[name='sndTest_Msg_type']:radio[value='GEN']").prop('checked', false);
            	$("input:radio[name='sndTest_Msg_type']:radio[value='RCS']").prop('checked', true);

            	$("input:radio[name='sndTest_Msg_type']:radio[value='GEN']").prop("disabled", true);
            	$("input:radio[name='sndTest_Msg_type']:radio[value='RCS']").prop("disabled", false);
            	
            	$("input:radio[name='sndTest_Msg_type']:radio[value='GEN']").hide();
            	$("input:radio[name='sndTest_Msg_type']:radio[value='RCS']").show();
            	
            	$('label[for="general"]').hide();
            	$('label[for="rcs"]').show();
            	break;
            
            case "GEN_RCS":
            	$("input:radio[name='sndTest_Msg_type']:radio[value='GEN']").prop('checked', true);
            	$("input:radio[name='sndTest_Msg_type']:radio[value='RCS']").prop('checked', false);

            	$("input:radio[name='sndTest_Msg_type']:radio[value='GEN']").prop("disabled", false);
            	$("input:radio[name='sndTest_Msg_type']:radio[value='RCS']").prop("disabled", false);
            	
            	$("input:radio[name='sndTest_Msg_type']:radio[value='GEN']").show();
            	$("input:radio[name='sndTest_Msg_type']:radio[value='RCS']").show();
            	
            	$('label[for="general"]').show();
            	$('label[for="rcs"]').show();

                $("#pop-testMsg #surveyType").val("GEN");
            	break;
            
            default:
            	console.log("popTestMsg : Invalid surveyType = %s", surveyType);
	            $("#pop-testMsg #surveyType").val("GEN");
            	break;
            }
        }

        function deletePhoneNum(obj){
            $(obj).closest("tr").remove();
            var testNumCnt = $("#testNumList tr").length;
            if(testNumCnt <= 1){
                $("#noCellPhone").css("display","");
            }
            resetNum();
        }

        function resetNum() {
            $(".cellPhoneRow").each(function(idx,obj){
                $(obj).find("td:first").text(idx+1);
            });
        }
        
        
        var stopCheckPrg = false;
		function startProgressbar() {
			
			var barProgress = jQuery(".progressbar");
			barProgress.find(".progress-label").html("0%");
			barProgress.progressbar({value:0});
			barProgress.find(".ui-progressbar-value").css({"background":"#CC66CC"});
			$("#processbarDiv").show();
			
			$(document).unbind( "ajaxComplete" );
			stopCheckPrg = false;
			pollCheckProgress();		
		}
		
		function stopProgressbar() {
			stopCheckPrg = true;
			$("#processbarDiv").hide();
			
			$("#popProcessingDiv").hide();
    		$("#_bgPrgss").hide();
			$(document).ajaxComplete(function() {
	    		$("#popProcessingDiv").hide();
	    		$("#_bgPrgss").hide();
	    		isProcessingAlertDisp = false;
	    	}); 
		}
		
		function pollCheckProgress() { 
			if(stopCheckPrg) return false;
			
			$.ajax({
		        url: '/survey/checkSurveyCalculateProgress',
		        type: 'GET',
		        async : false,
		        dataType: 'json',
		        success: function(response) {
		        	var tot = response.TOT_PROGRESS;
		        	var cmpl = response.CMPL_PROGRESS;
		        	var percent = (tot==0 ? 0 : cmpl/tot*100);
		        	console.log("pollCheckProgress : "+tot+" , "+cmpl+" , "+percent);
		        	
		        	var barProgress = jQuery(".progressbar");
		        	if(!isNaN(percent)) {
		        		barProgress.find(".progress-label").html(parseInt(percent)+"%");
						barProgress.progressbar({value:percent});	
		        	}
		        },
		        timeout: 3000,
		        complete: setTimeout(function() { pollCheckProgress(); }, 1000)
		    })
		}

    </script>
    <script type="text/javascript" src="<c:url value="/js/statCommon.js" />"></script>
</head>
<body>
<h2>설문 승인</h2>
<ul class="location clear p_a">
    ${locationInfo}
</ul>
<form:form commandName="searchForm" action="/survey/reqlist" method="POST" class="searchFrm clear">
    <input type='hidden' name="${_csrf.parameterName}" value="${_csrf.token}" />
    <input type="hidden" id="isNew" name="isNew" value="${isNew}"/>
    <input type="hidden" id="isExcel" name="isExcel" value="${isExcel}"/>
    <input type="hidden" id="isShow" name="isShow" value="${isShow}"/>
    <input type="hidden" id="ord1" name="ord1" value="${paramVO.ord1}" />
    <table>
        <colgroup>
            <col width="180px">
            <col width="*">
        </colgroup>
        <tbody>
        <tr>
            <th>설문 조회</th>
            <td>
                <label for="tgtCndUseYn">유형</label> |
                <wl:codeList inputType="select" cdGrpId="SURVEY_TARGET_YN_CD" id="tgtCndUseYn" name="tgtCndUseYn" defaultName="설문 전체" viewEmptyOption="Y" selectedVal="${paramVO.tgtCndUseYn}"></wl:codeList>
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <label for="surveyProjectNm">프로젝트(고객사)명</label> | <input type="text" id="surveyProjectNm" name="surveyProjectNm" class="space-check" placeholder="프로젝트(고객사)명" style="width: 200px;" maxlength="40" value="${paramVO.surveyProjectNm}">&nbsp;
                <label for="surveyTitle">설문(이벤트)명</label> | <input type="text" id="surveyTitle" name="surveyTitle" placeholder="설문(이벤트)명" value="${paramVO.surveyTitle}" style="width: 200px;" value="${paramVO.surveyTitle}">
            </td>
        </tr>
        <tr>
            <th>상태</th>
            <td>
                <form:radiobutton path="surveyStateCd" value="REQ_ALL" label="전체"/>&nbsp;&nbsp;
                <form:radiobutton path="surveyStateCd" value="REGISTER" label="승인요청"/>&nbsp;&nbsp;
                <form:radiobutton path="surveyStateCd" value="REJECT" label="반려"/>&nbsp;&nbsp;
                <form:radiobutton path="surveyStateCd" value="STOP" label="설문 중단"/>
            </td>
        </tr>
        <tr>
            <th>조회 기간</th>
            <td class="period">
                <ul class="clear">
                    <li><a href="javascript:void(0);" id="before1Day" >어제</a></li>
                    <li><a href="javascript:void(0);" id="before7Day" >7일</a></li>
                    <li><a href="javascript:void(0);" id="before1Month" >1개월</a></li>
                    <li><a href="javascript:void(0);" id="before3Month" >3개월</a></li>
                    <li><a href="javascript:void(0);" id="before1Year" >1년</a></li>
                </ul>&nbsp;&nbsp;&nbsp;&nbsp;
                <div class="calendar">
                    <form:input path="searchStartDate" id="from" readonly="true"/>~
                    <form:input path="searchEndDate" id="to" readonly="true"/>
                </div>
            </td>
        </tr>
        <tr>
            <th>조회 정보</th>
            <td class="contract_list">
                <security:authorize url="/stat/rlc/customlist">
                    <label for="rlcId" style="vertical-align:middle">중계사</label> |
                    <wl:codeList inputType="select" cdGrpId="RLC_TP_CD" id="rlcId" name="rlcId" selectedVal="${paramVO.rlcId}" defaultName="중계사 전체"></wl:codeList>
                    <label for="dlcId" style="vertical-align:middle">딜러사</label> |
                    <select id="dlcId" class="form-control " name="dlcId" for="" style="vertical-align:middle">
                        <option value="">딜러사 전체</option>
                        <c:if test="${not empty dealList }">
                            <c:forEach var="list" items="${dealList}" varStatus="i">
                                <option value="${list.dlcId}" <c:if test="${list.dlcId == paramVO.dlcId}">selected</c:if>>${list.dlcDPNm}</option>
                            </c:forEach>
                        </c:if>
                    </select>
                </security:authorize>
                <button type="button">고객사 선택</button>&nbsp;&nbsp;
                <label class="selBody" style="background:none;"></label>
                <input type="hidden" id="selCustId" name="selCustId" value="${param.selCustId}"/>
            </td>
        </tr>
        </tbody>
    </table>
    <button id="btnSubmit" type="button" class="f_r">검색</button>

    <div id="popCustomList" class="feePopup p_a" style="display: none;">
        <div class="top clear" style="height:30px;">
            <h5 class="f_l">고객사 선택</h5>
            <button class="f_r" type="button" style="background:url('../inc/img/btn_close.png') no-repeat center; border:none; margin-top:0; min-width:0">닫기</button>
        </div>
        <table id="tb-list" class="list">
            <thead>
            <tr>
                <th scope="row" style="text-align:left;padding-left:10px;">
                    <input type="checkbox" id="checkall" style="width:17px;height:17px;"/>
                    <input type="text" value="회사 이름" style="text-align:center;font-weight:bold;border:none;background-color:transparent;" readonly/>
                </th>
            </tr>
            </thead>
            <tbody>
            <tr>
                <td style="text-align:left; line-height:25px; padding-left:10px;">
                    <div id="divUserIdList" style="width:100%; height:300px; overflow:auto">
                        <c:forEach var="custom" items="${customList}">
                            <p><input type="checkbox" name="customIdList" id="searchCustomArr_${custom.userId}" value="${custom.userId}" style="width:17px;height:17px;"><label for="searchCustomArr_${custom.userId}">${custom.userNm}</label></p>
                        </c:forEach>
                    </div>
                </td>
            </tr>
            </tbody>
        </table>
        <button id="btnCancel" type="button" style="margin-top:0; min-width:0;">취소</button>
        <button class="f_r" id="btnPopSave" type="button" style="margin-top:0; min-width:0;">확인</button>
    </div>

    <div id="popReject" class="survey-approve-pop survey-approve-pop2 p_a" style="display: none;">
        <input type="hidden" id="popType" />
        <input type="hidden" id="popSeq" />
        <input type="hidden" id="surveySeq" />
        <input type="hidden" id="rejectTgtCndUseYn" />

        <div class="top clear" style="height:30px;">
            <button class="f_r" type="button" style="background:url('../inc/img/btn_close.png') no-repeat center; border:none; margin-top:0; min-width:0">닫기</button>
        </div>

        <div>
            <div class="desc"><label name="survey_title"></label>을(를) 반려하시겠습니까?</div>
            <textarea id="reject_ta" name="" placeholder="반려 사유를 입력해 주세요." maxlength="40"></textarea>
            <div class="error-message" style="display:none;">반려 사유를 입력해 주세요.</div>
        </div>

        <button type="button" class="cancelBtn" style="margin-top:0; min-width:0;">취소</button>
        <button class="f_r" id="rejectBtn" type="button" style="margin-top:0; min-width:0;">확인</button>
    </div>

    <div id="popReason" class="survey-approve-pop survey-approve-pop3 p_a" style="display: none;">
        <div class="top clear" style="height:30px;">
            <button class="f_r" type="button" style="background:url('../inc/img/btn_close.png') no-repeat center; border:none; margin-top:0; min-width:0">닫기</button>
        </div>
        <div>
            <div class="desc"><label name="survey_title"></label> 반려 사유:</div>
            <div class="reason">
            </div>
        </div>
        <div style="text-align:center;">        
        	<button type="button" style="margin-top:0; min-width:0;">확인</button>
        </div>
    </div>
</form:form>

<h4>Total : ${totalCnt}</h4>
<table id="tb-list" class="stat list">
    <thead>
    <tr>
        <th scope="row">No</th>
        <c:if test="${isShow}">
        <th scope="row">중계사</th> <!-- 2018.03.06 중계사 컬럼 추가 -->
        <th scope="row">딜러사</th>
        </c:if>
        <th scope="row">고객사명</th>
        <th scope="row">설문 유형</th>
        <th scope="row">MDN 지정 쿠폰</th>
        <th scope="row">프로젝트(고객사)명</th>
        <th scope="row">메시지 유형</th>
        <th scope="row">설문(이벤트)명</th>
        <th scope="row">수동대사</th>
        <th scope="row">발송 목표 건수</th>
        <th scope="row">정산 건수</th>
        <th scope="row">상태</th>
        <th scope="row">신청일시</th>
        <c:if test="${paramVO.ord1 eq 'ASC' }">
			<c:set var="ord1Class" value=" class='asc'" />
			<c:set var="ord1Nm" value="오름차순" />
		</c:if>
		<c:if test="${paramVO.ord1 eq 'DESC' }">
			<c:set var="ord1Class" value="" />
			<c:set var="ord1Nm" value="내림차순" />
		</c:if>
        <th scope="row"><a href="#" <c:if test="${not empty paramVO.ord1}"> class="on"</c:if>>시작일시<span ${ord1Class}>${ord1Nm}</span></a></th>
        <th scope="row">종료일시</th>
        <th scope="row">신청 ID</th>
        <th scope="row">설문 내용</th>
        <th scope="row" min-width="100px">테스트</th>
        <th scope="row">관리</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="surveyList" items="${list}" varStatus="i">
    <tr>
        <td data-seq-no="${surveyList.surveySeq}">${pageCnt - i.index}</td>
        <c:if test="${isShow}">
            <td data-seq-no="${surveyList.surveySeq}">${surveyList.rlcNm}</td>
            <td data-seq-no="${surveyList.surveySeq}"><c:if test="${not empty surveyList.dlcNm}">${surveyList.dlcNm}</c:if> </td>
        </c:if>
        <td data-seq-no="${surveyList.surveySeq}"><a href="javascript:goCustomerDetail('${surveyList.customId}');" style="text-decoration:underline;color:royalblue;">${surveyList.customNm}</a></td>
        <td data-seq-no="${surveyList.surveySeq}"><wl:codeValue cdGrpId="SURVEY_TARGET_YN_CD" cdId="${surveyList.tgtCndUseYn}"></wl:codeValue></td>
        <td data-seq-no="${surveyList.surveySeq}">
        	<c:choose>
        		<c:when test="${surveyList.agreCouponAssignYn eq 'Y'}">O</c:when>
        		<c:otherwise>-</c:otherwise>
        	</c:choose>
        </td>
        <td data-seq-no="${surveyList.surveySeq}">${surveyList.surveyProjectNm}</td>
        <td data-seq-no="${surveyList.surveySeq}">
        	<c:choose>
				<c:when test="${surveyList.surveyMsgTp eq null || surveyList.surveyMsgTp eq ''}">
					-
				</c:when>
				<c:otherwise>
					${surveyList.surveyMsgTp}
				</c:otherwise>
			</c:choose>
        </td>
        <td data-seq-no="${surveyList.surveySeq}" survey_title="Y" class="txt_left">${surveyList.surveyTitle}</td>
        <td data-seq-no="${surveyList.surveySeq}">
      	  <c:choose>
	        	<c:when test="${surveyList.bookingYn eq 'M'}">
	        		O
	        	</c:when>
	        	<c:otherwise>
		        	-
	        	</c:otherwise>
	        </c:choose>
        </td>
        <td data-seq-no="${surveyList.surveySeq}"><fmt:formatNumber value="${surveyList.surveyComplTargetCnt}" pattern="#,###" /></td>
        <td data-seq-no="${surveyList.surveySeq}"><fmt:formatNumber value="${surveyList.balanceAccountCnt}" pattern="#,###" /></td>
        <td data-seq-no="${surveyList.surveySeq}">
	        <c:choose>
	        	<c:when test="${surveyList.surveyStateCd eq 'REJECT' && surveyList.descr eq 'CSP 대사오류'}">
	        		설문 중단
	        	</c:when>
	        	<c:otherwise>
		        	<wl:codeValue cdGrpId="SURVEY_STATE_CD" cdId="${surveyList.surveyStateCd}"></wl:codeValue>
	        	</c:otherwise>
	        </c:choose>
        </td>
        <td data-seq-no="${surveyList.surveySeq}"><fmt:formatDate pattern="${fmtDateDetailSec}" value="${surveyList.updDttm}"/></td>
        <td data-seq-no="${surveyList.surveySeq}">${surveyList.surveyStartStr}</td>
        <td data-seq-no="${surveyList.surveySeq}">${surveyList.surveyEndStr}</td>
        <td data-seq-no="${surveyList.surveySeq}"><wl:maskFormat value="${surveyList.loginId}" format="ID"></wl:maskFormat></td>
        <td data-seq-no="${surveyList.surveySeq}"><button onclick="contentDownload(${surveyList.surveySeq})">다운로드</button></td>
        <td data-seq-no="${surveyList.surveySeq}">
        	<c:if test="${surveyList.surveyStateCd eq 'REGISTER'}">
        		<button onclick="popTestMsg(${surveyList.surveySeq}, '${surveyList.surveyType}')">발송</button>
        		<!-- <button class="btn-testMsg" id="sndTestMsg" survey-seq="${surveyList.surveySeq}" surveyType="${surveyList.surveyType}" type="button">발송</button> -->
        	</c:if>
        </td>
        <td data-seq-no="${surveyList.surveySeq}">
            <c:if test="${surveyList.surveyStateCd eq 'REGISTER'}">
                <button type="button" onclick="popApprove('${surveyList.customId}', '${surveyList.surveySeq}','${surveyList.tgtCndUseYn}', ${surveyList.surveySeq}, '${surveyList.surveyComplTargetCnt}', '${surveyList.agreCouponAssignYn}', '${surveyList.tgtCndUseYn}', '${surveyList.agreCouponCdFileUrl}', '${surveyList.surveyStateCd}', '${surveyList.surveyStartStr}', '${surveyList.bookingYn}')">승인</button>
                <button onclick="popReject(${surveyList.surveySeq}, ${surveyList.surveySeq}, this, '${surveyList.tgtCndUseYn}')">반려</button>
            </c:if>
            <c:if test="${surveyList.surveyStateCd eq 'REJECT'}">
                <button onclick="showReason(this)">사유</button>
            </c:if>
        </td>
        <td data-seq-no="${surveyList.surveySeq}" style="display: none;">${surveyList.descr}</td>
        <td data-seq-no="${surveyList.surveySeq}" style="display: none;">${surveyList.tgtCndCont}</td>
    </tr>
    </c:forEach>
    <c:if test="${empty list}">
        <tr>
            <td colspan="20"><fmt:message key="common.list.nodata"/></td>
        </tr>
    </c:if>
    </tbody>
</table>

<c:if test="${not empty list}">
    <%-- <c:url value="/survey/reqlist/downloadExcel" var="downExcel"/>
    <security:authorize url="${downExcel}">
        <button id="excelBtn" class="f_r" type="button">엑셀 리포트 다운로드</button>
        <form id="excelForm" action="" method="POST" target="ifrm">
            <input type="hidden" id="paramStr" name="paramStr" value="" />
            <input type="hidden" id="fieldInfo" name="fieldInfo" value="" />
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
        </form>
    </security:authorize> --%>
    <div class="paging">
        <wl:pagination formId="searchForm" pageList="${list}"></wl:pagination>
    </div>
</c:if>
<form id="frmApprove" action="/survey/updateState" method="POST" class="searchFrm clear">
	<input type='hidden' name="${_csrf.parameterName}" value="${_csrf.token}" />    
    <input type="hidden" id="isExcel" name="isExcel" value="${isExcel}"/>
    <input type="hidden" id="isShow" name="isShow" value="${isShow}"/>
    <input type="hidden" id="isFirst" name="isFirst" value="${isFirst}"/>
    <input type="hidden" id="popAgreCouponAssignYn" name="agreCouponAssignYn"/>
    <input type="hidden" id="popTgtCndUseYn" name="tgtCndUseYn" />
    <input type="hidden" id="popAgreCouponCdFileUrl" name="agreCouponCdFileUrl" />
    <input type="hidden" id="popBookingYn" name="bookingYn" />
	<div id="popApprove" class="survey-approve-pop survey-approve-pop1 p_a" style="display: none;">
		<input type="hidden" id="popCustomId" name="customId"/>
        <input type="hidden" id="popApproveId" name="surveySeq"/>
        <input type="hidden" id="popSurveyStateCd" name="surveyStateCd"/>
        <input type="hidden" id="popSurveyStartStr" name="surveyStartStr"/>
        <input type="hidden" id="checkingExceptYn" name="checkingExceptYn" value="N"/>
        <div class="top clear" style="height:30px;">
            <h5 class="f_l">타겟팅 설문 승인</h5>
            <button class="f_r cancelBtn" type="button" style="background:url('../inc/img/btn_close.png') no-repeat center; border:none; margin-top:0; min-width:0">닫기</button>
        </div>

        <div>
            <div class="st">타겟팅 조건</div>
            <textarea id="targetCondition" readonly></textarea>

            <div class="st">타겟팅 수신자</div>
            <input type="file" id="rcverPhoneNumFile" placeholder="수신자 번호 엑셀 파일">
            <input type="hidden" id="rcverPhoneNumFileUrl" name="rcverPhoneNumFileUrl" />
            <div class="stm">
            	<div class="bookingYn">
            		<input type="checkbox" id="exceptYn" name="exceptYn" /> 정보광고 수신 동의 대사 제외
            	</div>
            	<div class="bookingM" style="display:none;">
            		<span>해당 설문은 수동대사 입니다.</span>
            	</div>
            </div>
            <table>
                <tr>
                    <td>발송 목표 건수</td>
                    <td id="surveyComplTargetCnt"><span>0</span>건</td>
                    <input type="hidden" name="surveyComplTargetCnt"/>
                </tr>
                <tr>
                    <td>타겟팅 수신자 번호</td>
                    <td id="rcverPhoneNumCnt"><span>0</span>건</td>
                    <input type="hidden" name="rcverPhoneNumCnt"/>
                </tr>
                <tr>
                    <td>수신거부 번호</td>
                    <td id="rcvRjtPhoneNumCnt"><span>0</span>건</td>
                    <input type="hidden" name="rcvRjtPhoneNumCnt"/>
                </tr>
                <tr>
                    <td>엑셀 파일 내 중복된 번호</td>
                    <td id="dupPhoneNumCnt"><span>0</span>건</td>
                    <input type="hidden" name="dupPhoneNumCnt"/>
                </tr>
                <tr>
                    <td>진행중인 설문과 중복된 번호</td>
                    <td id="dupRunSurveyCnt"><span>0</span>건</td>
                    <input type="hidden" name="dupRunSurveyCnt"/>
                </tr>
                <tr>
                    <td>진행예정 설문과 중복된 번호</td>
                    <td id="dupExpectSurveyCnt"><span>0</span>건</td>
                    <input type="hidden" name="dupExpectSurveyCnt"/>
                </tr>
                <tr>
                    <td>유효하지 않은 번호</td>
                    <td id="errorPhoneNumCnt"><span>0</span>건</td>
                    <input type="hidden" name="errorPhoneNumCnt"/>
                </tr>
                <tr>
                    <td>발송 대상 수신자 번호</td>
                    <td id="targetNumCnt"><span>0</span>건</td>
                    <input type="hidden" name="targetNumCnt"/>
                </tr>
                <tr>
                    <td>MDN 별로 지정된 쿠폰 업로드 갯수</td>
                    <td id="assignedCouponCount"><span>0</span>건</td>
                    <input type="hidden" name="assignedCouponCount"/>
                </tr>
                <tr>
                    <td>랜덤 쿠폰 업로드 갯수</td>
                    <td id="randomCouponCount"><span>0</span>건</td>
                    <input type="hidden" name="randomCouponCount"/>
                </tr>
            </table>
        </div>
        <div id="approve-error-text" style="display:none;">
        	<span></span>
        </div>
        <br/>
		<div>
			<button type="button" id="appExcelBtn" class="f_r" style="margin-top:0; min-width:0;">엑셀리포트 요청</button>
		</div>
		<br/><br/><br/><br/>
		<div>
        	<button type="button" class="cancelBtn" style="margin-top:0; min-width:0;">취소</button>
        	<button class="f_r" id="approveBtn" type="button" style="margin-top:0; min-width:0;">승인</button>
        </div>
    </div>
</form>

<!--테스트 발송 팝업-->
    <div class="popWrap" id="pop-testMsg" style="display: none;">
        <div class="pop">
            <div class="top">
                <h4>테스트 설문 발송</h4>
                <button type="button" class="close" style="float: right;text-indent: -9999px;width: 19px;height: 19px;margin-top: 16px;border: none;min-width: 0px;background:url('../inc/img/closeBtn.png') no-repeat center;">닫기</button>
            </div>
            <form id="sndTestForm" action="/survey/updateState" method="POST" class="searchFrm clear">
                <input type="hidden" id="orgSurveySeq" name="orgSurveySeq" value="">
				<input type="hidden" id="surveyType" name="surveyType" value="">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="info">
                    <ul>
                        <li>테스트 설문을 발송할 번호를 입력 후 ‘확인’을 눌러주세요.</li>
                        <li>테스트 설문은 발송 1시간 후 자동 종료됩니다.</li>
                    </ul>
                    <span>※</span><p class="notice">설문 응답완료된 번호는 즉시 발송할 수 있습니다.</p>
                    <span>※</span><p class="notice">테스트 설문과 본 설문의 수신번호가 중복된 경우, 나중에 전송된 설문을 우선 처리합니다.</p>
                </div>
                <div>
					<div class="msg_type">
						<input type="radio" name="sndTest_Msg_type" id="sndTest_Msg_GEN" value="GEN" checked="checked">
						<label for="general">일반</label>
						<input type="radio" name="sndTest_Msg_type" id="sndTest_Msg_RCS" value="RCS">
						<label for="rcs">RCS</label>
					</div>
					<h5>테스트 메시지</h5>
					<span>※</span><p class="notice"> RCS 테스트시 수신단말의 RCS 지원 여부를 확인해 주세요. (메시지앱이 '채팅+' 인 경우만 가능)</p>
                    <h5>테스트 수신번호</h5>
                    <div class="tel">
                        <input type="text" class="input_tel number_only cellPhone" maxlength="3" id="cellPhone1" name="cellPhone1" />&nbsp;-
                        <input type="text" class="input_tel number_only cellPhone" maxlength="4" id="cellPhone2" name="cellPhone2" />&nbsp;-
                        <input type="text" class="input_tel number_only cellPhone" maxlength="4" id="cellPhone3" name="cellPhone3" />
                        <button type="button" id="addCellPhone"><img src="../inc/img/icon-add-q.png" alt="번호 추가"></button>
                    </div>
                    <span>※</span><p class="notice">SKT 가입자 번호만 가능합니다.</p>
                    <div class="table-wrap">
                        <table>
                            <colgroup>
                                <col width="47px">
                                <col width="154px">
                                <col width="75px">
                            </colgroup>
                            <thead>
                            <th>No</th>
                            <th>테스트 수신번호</th>
                            <th>관리</th>
                            </thead>
                            <tbody id="testNumList">
                                <tr id="noCellPhone">
                                    <td colspan="3">등록된 수신번호가 없습니다.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="btn">
                        <button type="button" class="cancelBtn">취소</button><button type="button" class="submit closeBtn blueBtn" id="sndTest">확인</button>
                    </div>
                </div>
            </form>
        </div>
    </div>
<!--테스트 발송 팝업-->

<wl:returnPageManager searchFormId="searchForm"/>

<form id="otherForm" method="POST">
    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
    ${hiddenParamters}
</form>
<form id="contentDownForm" method="get">

</form>

<form id="appExcelForm" action="" method="POST" target="ifrm">
	<input type="hidden" id="paramStr" name="paramStr" value="" />
	<input type="hidden" id="pageClCd" name="pageClCd" value="SV_TGT" />
	<input type="hidden" id="fieldInfo" name="fieldInfo" value="" />
	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
</form>

<div id="processbarDiv" class="progressbar_pop" style="overflow:hidden; margin-top:-150px; z-index:2000; display: none;" >
	<div class="progressbar"><div class="progress-label">0%</div></div>
</div>	

</body>
</html>
