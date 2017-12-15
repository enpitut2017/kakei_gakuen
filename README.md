# 家計学園(仮) / やっていき  
Heroku [![Build Status](https://travis-ci.org/enpitut2017/kakei_gakuen.svg?branch=master)](https://travis-ci.org/enpitut2017/kakei_gakuen)
AWS [![CircleCI](https://circleci.com/gh/enpitut2017/kakei_gakuen/tree/master.svg?style=svg)](https://circleci.com/gh/enpitut2017/kakei_gakuen/tree/master)

## 概要
> 既存の家計簿アプリの"続けられない"、"入力が面倒くさい"という問題を解決したい! 

そんな想いのもと誕生した新しい家計簿アプリが、この**家計学園**！  
この家計学園は通常の手入力に加えて、**音声入力で簡単に買い物の記録をする**ことができます。また、残高などを**ゲーム的に管理**することで、家計簿にありがちな"めんどくさいから入力しなくていいや"を解消することができます。  

## メンバー
[kobya4](https://github.com/kobya4)  
[Hassaku-kun](https://github.com/Hassaku-kun)  
[KatsuyaAkasaka](https://github.com/KatsuyaAkasaka)  
[tomoya-paseri](https://github.com/tomoya-paseri)  
[MinamiKaori](https://github.com/MinamiKaori)

## 秋学期

[活動内容](https://docs.google.com/presentation/d/1phSu8RyCM7EW4UvbenHvB6Iw4dSVXNC7gjnAFmQxGgo/edit?usp=sharing)
* [サービスのURL(AWS)](https://kakeigakuen.xyz/)
* [CircleCI](https://circleci.com/gh/enpitut2017/kakei_gakuen/)

### リリースノート
**2.1.0**  
ホーム画面から音声入力ができるようになりました。  

**2.0.0**  
溜まったコインで服を着せ変えられるようになりました。 
さらに購入に応じてグラフが表示されるので管理しやすくなりました。

**1.2.3**  
家計簿に入力した履歴の画面を一新し、見やすくなりました。  

**1.2.2**  
音声入力の使い方の説明を付け加えました。  
細かなバグの修正。  

**1.2.1**  
トップ画面から家計簿の入力ができるようになり、使いやすくなりました。  

**1.2.0**  
サーバを移行したので、操作が快適になりました。  

**1.1.2**  
他人の家計簿データを見れないようになり、セキュリティーが向上しました。  

**1.1.1**  
経験値及びレベルの制度が廃止され、代わりにコインのシステムを導入することで今後のアップデートに対応できるようになりました。  
今後のアップデートをお楽しみに！

**1.1.0**  
プロフィール設定をより直感的に操作できるようになりました。

## 春学期

### URL
* [サービスのURL](https://nameless-springs-98046.herokuapp.com/)
* [awsサービス](https://kakeigakuen.xyz/)
* [CI](https://travis-ci.org/enpitut2017/kakei_gakuen)
* [CircleCI](https://circleci.com/gh/enpitut2017/kakei_gakuen/)
* [カンバン](https://docs.google.com/spreadsheets/d/1gxHxn2aOs5fLqaxsvO0xVdqmIt4NJ-eUuDMCbEAsSuU/edit?usp=sharing)
### メンバー
[kobya4](https://github.com/kobya4)  
[Hassaku-kun](https://github.com/Hassaku-kun)  
[KatsuyaAkasaka](https://github.com/KatsuyaAkasaka)  
[tomoya-paseri](https://github.com/tomoya-paseri)  
[MinamiKaori](https://github.com/MinamiKaori)   
[muratananaho](https://github.com/muratananaho)  

### 開発効率化の工夫
- 作業を細かくしてまとめてマージするのではなく、細かくマージするようにしました。
- マージ後のエラー処理を確実に行うため、1日の中でミニスプリントを組んで、その単位でリリースできるようにしました。

### 改善点
**初日** 
タスクが大きすぎて、まとめてマージしようとしたのでエラーが起きて動かなかった

**二日目**  
知識不足によって、作業効率が悪化した
→ issueを使って効率化を図ろう

**三日目**  
マージする単位が大きかったので、エラーがたくさん起きた
→ マージする時間をグループ内で決めて細かくリリース

**四日目**  
今までの改善点を踏まえたので作業効率が大幅に向上し、安定してリリースできた

**五日目**  
四日目のやり方をベースに、作業の分担を考慮して開発
