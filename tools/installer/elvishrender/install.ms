fileIn "oiram.ms"
-- 弹出对话框提示用户需要重启3dsmax以完成安装
if queryBox "To complete the installation, restart the 3dsmax?" title:"information" do oiram_install "elvishrender"
