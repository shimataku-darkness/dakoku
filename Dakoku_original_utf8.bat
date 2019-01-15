@powershell/c '#'+(gc \"%~f0\"-ra)^|iex&exit/b

#######自分の情報########
$id = "0000"
$password = "??????"
#############################################################################################



$updates = "
# 2017/09/26 リトライ機能追加
# 2018/03/29 タイムゾーンを東京に固定
# 2019/01/08 新CWS対応"

if($id.equals("0000")){
	Write-Warning "このファイルをメモ帳などで開き(ファイルを右クリック→編集)、IDを自分用に変更してください。`n変更後、このファイルをダブルクリックで実行してください。`nOpen this file in Notepad and change `$id to your employee number, `nthen execute the file by double clicking."
	$host.UI.RawUI.ReadKey()
	exit;
}

Write-Warning " 東京タイムゾーンのみで利用可能です / This script is only available for Tokyo timezone."
echo "ID:$id"
echo "PASSWORD:$password"
$message = "再試行しますか / Try again?"

:Dakoku do
{
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12;
	$url = "?????????"#該当URLを入力
    $r = Invoke-WebRequest -Uri $url
    $f = $r.Forms[0]
    $f.Fields["dakoku"] = "syussya"
    $f.Fields["user_id"] = $id
    $f.Fields["password"] = $password
    $f.Fields["timezone"] = "540"

    $res = Invoke-WebRequest -Uri ("????????" + $f.Action) -Method POST -Body $f.Fields
    if(@($res.ParsedHtml.getElementsByTagName("body"))[0].OuterHTML.Contains("Clocked in succesfully")){
    	"Time: $([DateTime]::Now)"
        Write-Host "打刻成功 / Success!" -ForegroundColor Cyan
        $host.UI.RawUI.ReadKey()
        break Dakoku
    }else{
        Write-Warning "打刻失敗 / Failed `n"

        $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", `
        "再試行します / Retry dakoku"
        $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", `
        ("終了します / END" + $updates)

        $options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
		$result = $host.ui.PromptForChoice($title, $message, $options, 0)
		switch ($result)
    	{
        	0 {"再試行します / Retry Dakoku"}
        	1 {break Dakoku}
    	}

    }
}
while (1)


