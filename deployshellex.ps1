# extract tar file i.e sudo tar -xvf /shared/shellex.tar -C /shared/shellex
$filePath = "shellex.tar"
$output = "/shared/shellex"
sudo tar -xvf $filePath -C $output
# give permission shellex
sudo chmod +x $output/ShellEx
# restart ShellEx
sudo systemctl restart shellex
# see logs
sudo journalctl -u shellex -f
