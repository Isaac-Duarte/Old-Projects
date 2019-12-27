using System;
using System.Text;
using System.Collections.Generic;

namespace BinomialTheorem
{
    public class Format
    {
        /// <summary>
        /// This will format the expansion of a binomial
        /// </summary>
        /// <param name="pascalRow"></param>
        /// <param name="y"></param>
        /// <param name="exponet"></param>
        /// <returns></returns>
        public static string FormatExpansion(List<long> pascalRow, int y, int exponet)
        {
            int countOne = exponet;
            int countTwo = 0;

            StringBuilder stringBuilder = new System.Text.StringBuilder();

            if (y < 0)
            {
                y = y * -1;
            }

            foreach (long number in pascalRow)
            {
                stringBuilder.Append($"({number})(x)^{countOne}({y})^{countTwo} ");

                countOne -= 1;
                countTwo += 1;
            }

            return stringBuilder.ToString();
        }

        /// <summary>
        /// This will expand/simplify a binomal
        /// </summary>
        /// <param name="pascalRow"></param>
        /// <param name="y"></param>
        /// <param name="exponet"></param>
        /// <returns></returns>
        public static string Simplify(List<long> pascalRow, int y, int exponet)
        {
            int countOne = exponet;
            int countTwo = 0;
            double result = 0;
            bool addOrSubtract = false;

            int yPositive = y;
            
            StringBuilder stringBuilder = new System.Text.StringBuilder();

            if (yPositive < 0)
            {
                yPositive = yPositive * -1;
            }

            foreach (long number in pascalRow)
            {
                result = number * (Math.Pow(yPositive, countTwo));

                if(result > 1)
                {
                    stringBuilder.Append($"{result}");
                }
                
                if (countOne > 1 & countOne != 0)
                {
                    stringBuilder.Append($"x^{countOne}");
                }
                else if (countOne == 1)
                {
                    stringBuilder.Append($"x");
                }

                if (y > 0 & countOne > 0)
                {
                    stringBuilder.Append("+");
                }
                else if(addOrSubtract & countOne > 0)
                {
                    addOrSubtract = false;

                    stringBuilder.Append("+");
                }
                else if(countOne > 0)
                {
                    addOrSubtract = true;

                    stringBuilder.Append("-");
                }

                countOne -= 1;
                countTwo += 1;
            }

            return stringBuilder.ToString();
        }
    }
}