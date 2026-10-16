using System;
using System.Diagnostics;
using System.IO;
using System.IO.Compression;
using System.Reflection;

class CleanDroidSetup
{
    static int Main()
    {
        string dir = null;
        try
        {
            var asm = Assembly.GetExecutingAssembly();
            string res = null;
            foreach (var n in asm.GetManifestResourceNames())
            {
                if (n.EndsWith(".zip", StringComparison.OrdinalIgnoreCase)) res = n;
            }
            if (res == null) { Console.Error.WriteLine("Ic kaynak bulunamadi."); return 1; }

            dir = Path.Combine(Path.GetTempPath(), "CleanDroidSetup_" + Guid.NewGuid().ToString("N"));
            Directory.CreateDirectory(dir);
            string zip = Path.Combine(dir, "pkg.zip");
            using (var s = asm.GetManifestResourceStream(res))
            using (var f = File.OpenWrite(zip)) { s.CopyTo(f); }
            ZipFile.ExtractToDirectory(zip, dir);
            File.Delete(zip);

            string bat = Path.Combine(dir, "Kurulum.bat");
            if (!File.Exists(bat)) { Console.Error.WriteLine("Kurulum.bat cikartilamadi."); return 1; }
            var p = Process.Start(new ProcessStartInfo("cmd.exe", "/c \"\"" + bat + "\"\"") { UseShellExecute = false });
            p.WaitForExit();
            return p.ExitCode;
        }
        catch (Exception ex) { Console.Error.WriteLine("HATA: " + ex.Message); return 1; }
        finally
        {
            try { if (dir != null && Directory.Exists(dir)) Directory.Delete(dir, true); }
            catch { }
        }
    }
}
