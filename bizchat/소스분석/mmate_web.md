# mmate_web

# 분석
## 초기실행
WebApplicationConfig::
    -> XSSServletFilter::doFilterInternal
        -> /survey/saveSurvey
            -> 이면
                -> resolveMultipart(오버라이드) -> XssMultipartRequestWrapperForSurvey (파라메타 값 변경)
            -> 아니면
                -> resolveMultipart(오버라이드) -> XssMultipartRequestWrapper (파라메타 값 변경)
        -> CommonsMultipartResolver::isMultipart
            -> 이면
                -> CommonsMultipartResolver::resolveMultipart (* 파일업로드...관련)
            -> 아니면
                -> /survey/saveSurvey
                    -> 이면
                        -> XssRequestWrapperForSurvey::createRequest
                    -> 아니면
                        -> XssRequestWrapper::createRequest



# 참조사이트
1. 파일업로드
- [ファイルアップロード](https://terasolunaorg.github.io/guideline/1.0.3.RELEASE/ja/ArchitectureInDetail/FileUpload.html)
- [Spring MVCによるファイルアップロード](https://www.codeflow.site/ja/article/spring-file-upload)
- [Spring MVC ファイルのアップロード](https://qiita.com/MizoguchiKenji/items/0aa1f2b385e73c36c24d)