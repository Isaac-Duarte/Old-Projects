using System;
using System.Text;
using System.Collections.Generic;

namespace BinomialTheorem
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine(Format.FormatExpansion(Pascal.PascalRow(6), -6, 6));
            Console.WriteLine(Format.Simplify(Pascal.PascalRow(6), -6, 6));
        }
    }
}
