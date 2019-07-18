[toc]
# 使用iTerm2 自带的密码管理器输入密码

在密码管理器里面预设密码
打开 iTerm2, 菜单：Window -> Password Manager 打开密码管理器;
然后点击左下方的 + 号, 然后 添加一个密码

设置 trigger
打开 iTerm2, 菜单 iTerm2 -> Preference 然后开始设置
Profiles -> 选择你使用的profile,比如Default -> Advanced -> Trigger -> Edit -> 打开 Triggers
右下角 + 号,
Regular Expression -> ssh.* Action: Open Password Manager
Parameter: 选择你上一步输入的密码管理器的设置的;