using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.IO;

namespace CFStatBridge
{
    /// <summary>
    /// Summary description for Form1.
    /// </summary>
    public class ArmaAAR : System.Windows.Forms.Form
    {
        private System.ComponentModel.IContainer components;
        /// <summary>
        /// opens file path to write stream to file.
        /// writes every tick defiend by embedded timer.
        /// </summary>
        private static FileStream fs = new FileStream(@"aar.sqf", FileMode.OpenOrCreate, FileAccess.Write);
        private System.Windows.Forms.Timer timer1;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button button2;
        private TextBox txtDisplay;
        private static StreamWriter m_streamWriter = new StreamWriter(fs);


        public ArmaAAR()
        {
            // Required for Windows Form Designer support
            InitializeComponent();
        }
        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (components != null)
                {
                    components.Dispose();
                }
            }
            base.Dispose(disposing);
        }
        #region Windows Form Designer generated code
        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.button1 = new System.Windows.Forms.Button();
            this.button2 = new System.Windows.Forms.Button();
            this.txtDisplay = new System.Windows.Forms.TextBox();
            this.SuspendLayout();
            // 
            // timer1
            // 
            this.timer1.Interval = 100;
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(12, 24);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(80, 32);
            this.button1.TabIndex = 0;
            this.button1.Text = "Start";
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(200, 24);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(80, 32);
            this.button2.TabIndex = 1;
            this.button2.Text = "Stop";
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // txtDisplay
            // 
            this.txtDisplay.Location = new System.Drawing.Point(12, 101);
            this.txtDisplay.Multiline = true;
            this.txtDisplay.Name = "txtDisplay";
            this.txtDisplay.ScrollBars = System.Windows.Forms.ScrollBars.Both;
            this.txtDisplay.Size = new System.Drawing.Size(268, 115);
            this.txtDisplay.TabIndex = 2;
            // 
            // ArmaAAR
            // 
            this.AutoScaleBaseSize = new System.Drawing.Size(5, 13);
            this.ClientSize = new System.Drawing.Size(297, 280);
            this.Controls.Add(this.txtDisplay);
            this.Controls.Add(this.button2);
            this.Controls.Add(this.button1);
            this.Name = "ArmaAAR";
            this.Text = "Arma 2 Group AAR";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }
        #endregion
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.Run(new ArmaAAR());
        }

        private void Form1_Load(object sender, System.EventArgs e)
        {
            // Write to the file using StreamWriter class 
            m_streamWriter.BaseStream.Seek(0, SeekOrigin.End);
            m_streamWriter.Write(" //Arma 2 group Starts : ");
            txtDisplay.Text = "Arma 2 Group AAR Module";
            m_streamWriter.WriteLine("//{0} {1}", DateTime.Now.ToLongTimeString(), DateTime.Now.ToLongDateString());
            m_streamWriter.WriteLine("// ===================================== \n");
            m_streamWriter.Flush();
            Clipboard.Clear();
        }
        /// <summary>
        /// Fired periodically defined by embedded timer
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void timer1_Tick(object sender, System.EventArgs e)
        {
            string _dataFromClip;
            _dataFromClip = Clipboard.GetText();
            txtDisplay.Text = Clipboard.GetText();
            ///_start is message sent from other application
            bool Arma_MessageRecieved = txtDisplay.Text.StartsWith("Arma_message");
            //if _start wasn't sent then write will not occur
            if (Arma_MessageRecieved)
            {
                m_streamWriter.WriteLine("{0}", _dataFromClip);
                m_streamWriter.Flush();
                Clipboard.Clear();
            };
        }

        private void button1_Click(object sender, System.EventArgs e)
        {
            timer1.Enabled = true;
            button1.Enabled = false;
            button2.Enabled = true;
        }

        private void button2_Click(object sender, System.EventArgs e)
        {

            timer1.Enabled = false;
            button1.Enabled = true;
            button2.Enabled = false;
        }
    }
}
