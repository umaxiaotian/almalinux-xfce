FROM almalinux:8.8

# Set root password
RUN echo 'root:password' | chpasswd


# 言語を日本語に設定、これで日本語ファイル名もちゃんと表示される
RUN dnf -y install glibc-locale-source glibc-langpack-en
# =>上記を実施しないと、[error] character map file `UTF-8' not found: No such file or directoryのエラーとなってしまう
RUN localedef -i ja_JP -f UTF-8 ja_JP.UTF-8
RUN echo 'LANG="ja_JP.UTF-8"' >  /etc/locale.conf
ENV LANG ja_JP.UTF-8

# 日付を日本語に設定
RUN echo 'ZONE="Asia/Tokyo"' > /etc/sysconfig/clock
RUN rm -f /etc/localtime
RUN ln -fs /usr/share/zoneinfo/Asia/Tokyo /etc/localtime

RUN echo -e "[google-chrome]\nname=google-chrome\nbaseurl=http://dl.google.com/linux/chrome/rpm/stable/x86_64\nenabled=1\ngpgcheck=1\ngpgkey=https://dl.google.com/linux/linux_signing_key.pub" > /etc/yum.repos.d/google-chrome.repo

# EPELとPowerToolsリポジトリの有効化
RUN dnf install -y epel-release && \
    dnf config-manager --set-enabled powertools

# 必要なパッケージのインストール
RUN dnf update -y && \
    dnf groupinstall -y "Xfce" && \
    dnf install -y tigervnc-server novnc xorg-x11-fonts-Type1 xorg-x11-fonts-misc google-chrome-stable firefox && \
    dnf clean all


#不要ライブラリ削除
RUN dnf remove -y xfce4-power-manager
RUN rm /etc/xdg/autostart/xfce-polkit*
# RUN dnf -y remove xfce4-polkit

# PolicyKitの削除
# RUN dnf remove -y polkit polkit-libs polkit-pkla-compat && \
#     dnf autoremove -y && \
#     dnf clean all

# Set up Japanese language support
RUN dnf install -y ibus-kkc vlgothic-fonts && \
    echo "export GTK_IM_MODULE=ibus" >> ~/.bashrc && \
    echo "export XMODIFIERS=@im=ibus" >> ~/.bashrc && \
    echo "export QT_IM_MODULE=ibus" >> ~/.bashrc && \
    dbus-uuidgen > /var/lib/dbus/machine-id

# Set up VNC
RUN mkdir ~/.vnc
RUN echo "password" | vncpasswd -f > ~/.vnc/passwd
RUN chmod 600 ~/.vnc/passwd

# Set up noVNC
RUN rm -f /usr/share/novnc/index.html && ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html


# Set up Chrome
RUN echo "export DISPLAY=:1" >> ~/.bashrc

# Set up XFCE
RUN echo "exec /usr/bin/startxfce4" >> ~/.vnc/xstartup
RUN chmod +x ~/.vnc/xstartup

# Expose VNC and noVNC ports
EXPOSE 5901 6080

# Start VNC server and noVNC web server
CMD vncserver :1 -geometry 1280x800 -depth 24 && \
    websockify --web /usr/share/novnc/ 6080 localhost:5901