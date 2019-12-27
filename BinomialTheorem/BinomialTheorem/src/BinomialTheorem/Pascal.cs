using System;
using System.Collections.Generic;

namespace BinomialTheorem
{
    class Pascal
    {
    
    /// <summary>
    /// This will return the row numbers for a Pascal Triangle
    /// </summary>
    /// <param name="rowNumber">The desired row</param>
    /// <returns>A List of long integers</returns>
     public static List<long> PascalRow(long rowNumber)
     {
         // Establish a new list
        List<long> results = new List<long>();
        
        // Add the starter value. 
        long value = 1;
        results.Add(value);

        // Calculate the values
        for (int k = 1; k <= rowNumber; k++)
        {
            value = (value * (rowNumber + 1 - k)) / k;
            results.Add(value);
        }

        return results;
     }
    }    
}