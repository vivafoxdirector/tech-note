# GIT

# 기본 명령어
## 로컬 레포지토리 생성
```
git init
git add .  or git add *
git commit -m "initial commit"
```

## 로컬 레포지토리 가져오기
```
git clone [리모트 레포지토리 주소]
```

## 파일 업데이트 기본 순서
* 파일 추가
* 파일 커밋
* 파일 갱신
```
git add                         // 파일 추가
git commit -a -m "메시지"        // 파일 커밋
git push origin master          // 파일 갱신
```

### git add 사용
```
git add .                       // 모든 디렉토리/파일
git add *.css                   // 모든 CSS파일
git add -n                      // 추가된 파일 확인
git add -u                      // 갱신된 파일 추가
git rm --cached                 // add시킨 파일 제외
```
### git commit 사용
```
git commit -a                   // 수정된 모든 파일
git commit --amend              // 직전 커밋 취소
git commit -v                   // 변경지점을 표시하고 커밋
```
### git commit 취소
```
git reset --soft HEAD~2         // 최근 커밋부분에서 이전 커밋 2번째 지점으로 이동??
git reset --hard HEAD~2         // 최근 커밋부분에서 이전 커밋 2번째 지점으로 이동??
```

## git reset ??
### git 기초
- working tree : 파일의 최근 상태
- index [stage] : 커밋하기 바로 직전의 상태
- local repository : 파일 변경 이력을 기록(로컬보관)
	- HEAD : 최신 커밋 상태
- remote repository : 파일 변경 이력을 기록(리모트보관)

## STAGE
### :: Stage에 있는 이력 삭제하기
```
git reset HEAD [파일명/파일패스]
```

### :: UnStage 파일 삭제
```
git checkout [파일명/파일패스]
git checkout master
```

## LOG
### 로그 확인
```
git log
```

### 파일명만 확인
```
git log --name-only
```

### 로그 그래프 확인
* detail
```
git log --graph
```
* more detail
```
git log --graph --branches --pretty=format:"%d [%h] \"%s\""
git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
git log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
```

## TAG
* show tag information
```
git show [Tag Name]
```

* checkout from tag
```
git check [Tag Name]
```

* branch from tag
```
git branch [Branch Name] [Tag Name]
git checkout [Branch Name]
```

## Git Config
### GIT 설정파일내용 보기
```
cat .git/config
```
### GIT 유저에 따른 설정
```
git config --global core.editor vim
[--global]옵션을 넣으면, ~/.gitconfig파일을 설정하게 됨. 위와 같은
명령어를 하면 [core] 장소에 [editor=vim]을 추가하게 됨.
```

### 특정 설정파일을 지정
```
git config -l -f .git/config
[-f]옵션은 특정 파일에 설정정보를 지정함.
```

### 유저고유(유저마다다르기 때문)레포지토리 설정 보기
```
git config -l --global
또는
cat ~/.gitconfig
```

### GIT 레포지토리 설정으로 사용하는 값을 표시하기
```
git config -l
위 명령어로 [--global][--local][--system]각각의 옵션의 내용을 전체 표시를 함.
```

### 레포지토리 설정키를 정규표현을 사용하여 검색값을 표시하기
```
git config --get-regexp "^color"
[--get-regexp]옵션을 사용하여 color로 시작하는 단어 검색
```

### 레포지토리 설정파일을 편집하기
```
git config -e    
또는
git config -e --global
```

### 설정정보 보기
```
git config --get user.email
[--get]옵션을 사용하여 가져온다.
```

### 디폴트 유저명, 유저메일정보 설정
```
git config --global user.email "Your email"
git config --global user.name "Your name"
```

### 각레포지토리 고유 유저명,메일정보 설정
```
git config user.email "Your email"
git config user.name "Your name"
```

### 에디터/페이저를 설정하기
```
git config --global core.editor vim
git config --global core.pager "lv -c"
```

### 명령어 Alias설정하기
```
git config --global alias.co "checkout"
git config --global alias.ci "commit"
SVN의 [checkout]을 [co]로, [commit]을 [ci]로 함.
```

### 단말에 색깔문자를 출력
```
git config --global color.ui auto
[color.branch]
[color.diff]
[color.interactive]
[color.status]
값을 설정 할 수도 있음.
```

## Git ignore

### 이미 레포지토리에 gitignore를 추가하였다면, 캐쉬에 남게되어있다. 이를 수정하면 반영이 안된다. 해결은 아래와 같은 방법
```
git rm -r --cached .
git add .
git commit -m "message"
git push -u origin master
```

## 수정 레포지토리 다루기
### 수정된 것을 다시 원위치
참조: https://tnakamura.hatenablog.com/entry/20090504/1241398150
* 특정 파일만
```
git checkout [파일명]
```
* 전체
```
git checkout .
```

### 수정된 소스 로컬 feature에 반영
작업을 feature/NewFeature 브런치에서 작업을 했다면

1. develop 브런치로 변경
```
feature/NewFeature> git checkout develop
```
2. feature 에 있는 것을 develop브런치에 반영
```
develop> git merge feature/NewFeature develop
```
3. 현브런치의 내용을 리모트의 develop브런치에 반영
```
develop> git push origin develop
```

## 오버라이트 및 반영
### remote에 있는것을 로컬 레포지토리에 오버라이트 하기
```
git fetch origin
git reset --hard origin/master
```


### origin에 있는 소스 반영
```
git fetch
git merge
-------------------
git pull  <--- fetch + merge
```

### 자신의 마스터와 비교하여 어떤 파일이 다른지 확인하기>
```
git diff HEAD
```

### 다른파일 목록만 나오게 확인
```
git diff --name-only
```

### 로지컬에 있는 파일과 자신의 마스터와 비교하여 어떤 파일이 다른지 확인하기
```
git fetch  <-- 우선 로지컬에 있는것을 어떤 변화가있는지 적용
git diff FETCH_HEAD <-- 자신의 마스터와 비교하여 어떤 파일의 어떤 내용이 변경되었는지 확인
git diff FETCH_HEAD --name-only <-- 자산의 마스터와 비교하여 어떤 파일목록이 변경되었는지 확인
```

### remote에 push하기 전에 rebase를 해주어라
```
git rebase
```

## Git Log
### git의 graph 보기
```
git log --graph  <-- 더 상세하게는 아래의 명령어
git log --graph --branches --pretty=format:"%d [%h] \"%s\""   <-- 더더욱 상세하게는 아래의 명령어
git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
git log --graph --all --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative
```

### git entry 삭제
* 참조 : http://jampin.blog20.fc2.com/blog-entry-122.html
```
git rm test.txt
위의 것이 안되면
git rm -r test.txt
```

## Git Tag
* 참조: http://milligramme.cc/wp/archives/4374

### 로컬에 tag추가하기
```
git tag v0.9
```
### 리모트에 반영
```
git push origin v0.9
```
### tags 리모트에 push 하기
```
git push origin —tags
```
### 리모트에 있는 tags들을 pull하기
```
git pull —tags
```
### 리모트에 있는 tag 목록 보기
```
git ls-remote --tags
* 
git checkout -b [BRANCH_NAME] [TAG_NAME]
```

### tags 삭제
* 참조: http://qiita.com/usamik26/items/7e53bae128bf130b8a32
```
git tag  <-- tag 리스트 보기
git tag -d [TAGNAME]
git push origin :[TAGNAME]
```

### tag 명과 브런치 명이 같아서 삭제가 안되는 경우
* Tag를 삭제하는 경우
```shell
git push origin :refs/tags/<tag_name>
```

* 브런치를 삭제하는 경우
```shell
git push origin :refs/heads/<branch_name>
```

### git tag 리모트확인
* 참조: http://buchi.hatenablog.com/entry/2015/02/27/122830
```
git ls-remote --tags
```

## Git Branch
### origin branch 확인
```
git branch -r
```

### origin branch checkout
```
git branch -r
git branch [branchname] [origin/branchname]
```

### branch 작성
```
git checkout-b [branchname]
```

### branch 삭제
* 참조: http://qiita.com/usamik26/items/7e53bae128bf130b8a32
```
git branch <-- branch 리스트 보기
git branch -d [BRANCHNAME]
git push origin :[BRANCHNAME]
```

## Git stash

### stash 무시하고 pull하기
* 참조: https://qiita.com/izcomaco/items/78030cb1bb269234cf6f
* 아래와 같은 오류가 나는 경우
```
error: Your local changes to the following files would be overwritten by merge:
directoryname/filename
Please, commit your changes or stash them before you can merge.
```
```
git stash save -u          // 최신 작업 공간에서 후퇴
git status                 // 상태 확인
git stash list             // 일시 보존 파일 리스트 확인
git pull                   // remote 에서 가져오기
git stash pop              // 최신 작업 공간에 되돌린다.
```

## REF
- 내용: git config
    - 참조 : http://transitive.info/article/git/command/config/

- 내용: git reset
    - 참조: http://qiita.com/annyamonnya/items/d845597606fbabaabcad

- 내용: git rebase
    - 참조: https://qiita.com/annyamonnya/items/d845597606fbabaabcad
    
- 내용: git add관련
    - 참조: http://kimromi.hatenablog.jp/entry/2015/08/04/082357

- 내용: gitignore 파일 포맷 정리
    - 참조 : http://d.hatena.ne.jp/maeharin/20130206/gitignore
    - 참조 : http://www.omakase.org/misc/gitignore.html
    - 참조 : http://qiita.com/asonas/items/abdbf1208e832b5dd0eb

- 내용: git reset
    - 참조 : http://www-creators.com/archives/1116
	- 참조 : https://qiita.com/shuntaro_tamura/items/db1aef9cf9d78db50ffe

- 내용: git conplicit
	- 참조 : https://qiita.com/crarrry/items/c5964512e21e383b73da

### 오류대응
- 내용 : src refspec master does not match any.
    - 참조 : http://d.hatena.ne.jp/nishiohirokazu/20110304/1299229916

- 내용 : git push 오류 발생되었을때
    - 참조 : http://nilfigo.hatenablog.com/entry/2013/08/09/145435
