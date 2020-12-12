using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Security.Cryptography;
using Xunit;
using Xunit.Abstractions;

namespace XUnitTestProject1
{
    public class UnitTest1
    {
        private readonly ITestOutputHelper output;
        private string _jwe_secret_key;
        private string _jwe_iv;

        public UnitTest1(ITestOutputHelper output)
        {
            _jwe_secret_key = "WeWF4BcyX/nKXUph9hMy4g==\n";
            _jwe_iv = "FZD40DZJDEYZbw/PTYAZlQ==\n";
            this.output = output;
        }


        [Fact]
        public void Test2()
		{
        }

        [Fact]
        public void Test1()
        {
            string t = "2yIfStnuG+LQ/d7Cy+O9BEBsSVyJLxP5B3cAUaoprSI=\n";
            var obj = DecryptToken(t) ;
            output.WriteLine("output {0}", obj["vnc"]);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="authHeader"></param>
        /// <returns></returns>
        public Dictionary<string, string> DecryptToken(string authHeader)
        {
            string headerinfo = string.Empty;

			using (var memorystream = new MemoryStream(Convert.FromBase64String(authHeader)))
			{
				using (AesCryptoServiceProvider aesAlg = new AesCryptoServiceProvider() {
                    Key = Convert.FromBase64String(_jwe_secret_key), 
                    IV = Convert.FromBase64String(_jwe_iv), 
                    Mode = CipherMode.CBC
                })
				{
					using (ICryptoTransform icrypt = aesAlg.CreateDecryptor())
					{
						using (CryptoStream cryptstream = new CryptoStream(memorystream, icrypt, CryptoStreamMode.Read))
						{
							using (StreamReader streamreader = new StreamReader(cryptstream))
							{
								headerinfo = streamreader.ReadToEnd();
							}
						}
					}

				}
			}

			return JsonConvert.DeserializeObject<Dictionary<string, string>>(headerinfo);
        }
    }
}
