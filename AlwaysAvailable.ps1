# Add the System.Windows.Forms assembly to enable GUI creation
Add-Type -AssemblyName System.Windows.Forms

# Initialize a variable to track Caps Lock toggling state
$toggleEnabled = $false

# Create a new Windows Form object
$Form = New-Object Windows.Forms.Form

# Configure form properties
$Form.Text = "Always Available"
$Form.Size = New-Object Drawing.Size(300, 150)
$Form.FormBorderStyle = "FixedDialog"

# Create a label to display information
$ToggleLabel = New-Object Windows.Forms.Label
$ToggleLabel.Text = "Toggle Caps Lock every 5 seconds"
$ToggleLabel.Location = New-Object Drawing.Point(20, 20)
$ToggleLabel.AutoSize = $true
$Form.Controls.Add($ToggleLabel)

# Create a button to enable/disable Caps Lock toggling
$ToggleButton = New-Object Windows.Forms.Button
$ToggleButton.Text = "Enable"
$ToggleButton.Location = New-Object Drawing.Point(100, 60)
$ToggleButton.Size = New-Object Drawing.Size(100, 30)
$ToggleButton.Font = New-Object Drawing.Font("Arial", 10)
$ToggleButton.Add_Click({
    # Toggle the Caps Lock state and update button text
    if ($global:toggleEnabled) {
        $global:toggleEnabled = $false
        $ToggleButton.Text = "Enable"
    } else {
        $global:toggleEnabled = $true
        $ToggleButton.Text = "Disable"
        Start-Timer
    }
})
$Form.Controls.Add($ToggleButton)

# Create a timer to toggle Caps Lock state
$Timer = New-Object System.Windows.Forms.Timer
$Timer.Interval = 5000  # 5 seconds in milliseconds
$Timer.Add_Tick({
    if ($global:toggleEnabled) {
        [System.Windows.Forms.SendKeys]::SendWait("{CAPSLOCK}")
    }
})

# Define function to start the timer
function Start-Timer {
    $Timer.Start()
}

# Define function to stop the timer
function Stop-Timer {
    $Timer.Stop()
}

# Stop the timer initially
$Timer.Stop()

# Create an "About" menu item
$aboutMenuItem = New-Object System.Windows.Forms.ToolStripMenuItem
$aboutMenuItem.Text = "About"
$aboutMenuItem.Add_Click({
    [System.Windows.Forms.MessageBox]::Show("Made by Roger Anderson @akioroson")
})

# Create a menu strip and add the "About" menu item
$menuStrip = New-Object System.Windows.Forms.MenuStrip
$menuStrip.Items.Add($aboutMenuItem)

# Attach the menu strip to the form
$Form.Controls.Add($menuStrip)

# Hide the PowerShell console window
Add-Type -TypeDefinition @'
using System;
using System.Runtime.InteropServices;

public class ConsoleWindow {
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();

    [DllImport("user32.dll")]
    [return: MarshalAs(UnmanagedType.Bool)]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);

    public static void Hide() {
        IntPtr hWnd = GetConsoleWindow();
        if (hWnd != IntPtr.Zero) {
            ShowWindow(hWnd, 0); // 0 = SW_HIDE
        }
    }
}
'@

# Hide the console window using the defined class
[ConsoleWindow]::Hide()

# Display the form as a dialog
$Form.ShowDialog()
