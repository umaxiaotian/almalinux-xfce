
## 日本語のAlmaLinuxとxfce4を使用したLinuxデスクトップをnoVNCでウェブブラウザからホストするコンテナ
![image](https://github.com/umaxiaotian/almalinux-xfce/assets/29545778/5ea0912b-1cc1-4677-9bce-12705ff9bf69)

**説明:**
私はAlmaLinuxとxfce4を使用して日本語のAlmaLinux上で動作するLinuxデスクトップを作成し、noVNC技術を用いてウェブブラウザからアクセス可能な状態にするコンテナを作成しました。イメージをプルする際は、'umaxiaotian/almalinux-xfce'のようにイメージ名を指定し、noVNCはポート6080でアクセス可能です。

**主な特徴:**
- **ベースOS: 日本語のAlmaLinux** - 安定性とセキュリティに優れたLinuxディストリビューションである日本語のAlmaLinuxをベースにしています。
- **デスクトップ環境: xfce4** - 軽量で使いやすいxfce4デスクトップ環境を利用し、リソース効率の高さと快適なインターフェースを提供します。
- **noVNCサポート** - noVNCを統合しており、ウェブブラウザを通じて追加のクライアントソフトウェアを必要とせずにデスクトップにリモートアクセスできます。

**利用方法:**
1. Docker環境を準備します。Dockerがインストールされていない場合は、公式リソースを参考にインストールします。
2. 以下の内容で`docker-compose.yml`ファイルを作成します:

   ```yaml
   version: '3'
   services:
     linux-desktop:
       image: umaxiaotian/almalinux-xfce
       ports:
         - "6080:80"
