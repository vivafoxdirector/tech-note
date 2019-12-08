# Hexo

# Start
1. install
```
npm install -g hexo
```

2. Project
```
hexo init myblog
cd myblog
npm install
hexo server
```

3. github
_config.yml
```
deploy:
  type: git
  repo: https://github.com/vivafoxdirector/vivafoxdirector.github.io.git
  branch: master
  ...
```

4. deploy
```
hexo deploy -g
```

5. 기사 추가
```
hexo new "기사"
=> 마크다운으로 기사 작성

hexo d -g
```

# 참조사이트
- [所要時間3分!? Github PagesとHEXOで爆速ブログ構築してみよう！](https://liginc.co.jp/web/programming/server/104594)
