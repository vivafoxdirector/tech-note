# Homebrew

## 개요
Homebrew는 Mac용 패키지 매니저이다. 본 문서는 Homebrew의 명령어를 정리한 것이다.

## 인스툴
```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

## zsh 명령어 보조 설정
"/usr/local/Library/Contributions/"아래의 bash나 zsh용 brew명령어 보완 함수가 추가된다. 그것을 zsh에 읽히게 하면 된다.
```
cd /usr/local/share/zsh/site-functions
ln -s ../../../Library/Contributions/brew_zsh_completion.zsh _brew
```

## 명령어
### 인스툴
```
brew install formula
```

### 검색
'/'을 사용하면 정규표현 검색이다.
```
brew search text
brew search /text/
```

### 설치된 목록 보기
인스툴된 formula 리스트 표시
```
brew list
brew -v list
```

### 언인스툴
```
brew uninstall formula
```

### 업데이트된것이 있는지 formula확인
```
brew outdated
```

### 오래된 버전(outdated) formular 삭제
```
brew cleanup
brew cleanup -n    # 어떤것이 삭제되는지 리스트표시
```

### Homebrew와 formular 업데이트
```
brew update
brew update (formular | 지정않으면 전체)  # 업데이트되는 패키지는 재빌드한다
```

### formular 정보 보기
```
brew info formula
```

### 의존관게 보기
```
brew deps formula
brew deps --tree formular   # tree 표현
```

### formular 활설 비활성
```
brew link formula
brew unlink formula
```

### brew 문제없는지 확인
```
brew doctor
```

### Homebrewprefix로 데드심볼릭링크 삭제
```
brew prune
```

### tap/untap
```
brew tap 유저명/레포지토리명
brew untap 유저명/레포지토리명   # 이 레포지토리로 인스툴한 formula는 먼저 삭제해둔다.
```

### tap하거나 레포지토리 목록 표시
```
brew tap
```

### brew 로 pull request를 pull한다
```
brew pull [Address]
```

# 참조사이트
* [Homebrew使い方まとめ](https://qiita.com/vintersnow/items/fca0be79cdc28bd2f5e4)
* [今さらだけどHomebrewのコマンドをちゃんと理解して使おう](https://qiita.com/fuqda/items/db8aff0ba4068aea2cc6)