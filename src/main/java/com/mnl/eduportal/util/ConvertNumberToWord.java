/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.mnl.eduportal.util;

import java.util.Random;

/**
 *
 * @author eaglescan
 */
public class ConvertNumberToWord {
    public String[] units = {
        "", "One", "Two", "Three", "Four", "Five", "Six", "Seven",
        "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen",
        "Fifteen", "Sixteen", "Seventeen", "Eighteen", "Nineteen"
    };

    public String[] tens = {
        "", // 0
        "", // 1
        "Twenty", // 2
        "Thirty", // 3
        "Forty", // 4
        "Fifty", // 5
        "Sixty", // 6
        "Seventy", // 7
        "Eighty", // 8
        "Ninety" // 9
    };

    public String convert(int n) {
        if (n < 0) {
            return "minus " + convert(-n);
        }

        if (n < 20) {
            return units[n];
        }

        if (n < 100) {
            return tens[n / 10] + ((n % 10 != 0) ? " " : "") + units[n % 10];
        }

        if (n < 1000) {
            return units[n / 100] + " Hundred" + ((n % 100 != 0) ? " " : "") + "and "+convert(n % 100);
        }

        if (n < 1000000) {
            return convert(n / 1000) + " Thousand" + ((n % 1000 != 0) ? ", " : "") + convert(n % 1000);
        }

        if (n < 1000000000) {
            return convert(n / 1000000) + " Million" + ((n % 1000000 != 0) ? ", " : "") + convert(n % 1000000);
        }

        return convert(n / 1000000000) + " Billion" + ((n % 1000000000 != 0) ? ", " : "") + convert(n % 1000000000);
    }
    
    public String convertAmount(double number){
        String words="";
        try{
            String sam = number+"";
            if(sam.contains(".")){
                
            }else{
                sam = sam+".00";
            }
            String naira = sam.substring(0, sam.indexOf("."));
            String kobo = sam.substring(sam.indexOf(".")+1, sam.indexOf(".")+2);
            try{
                kobo = sam.substring(sam.indexOf(".")+1, sam.indexOf(".")+3);
            }catch(Exception as){}
            int inaira = 0;
            int ikobo = 0;
            try{
                inaira = Integer.parseInt(naira);
            }catch(NumberFormatException k){}
            try{
                ikobo = Integer.parseInt(kobo);
            }catch(NumberFormatException k){}
            words = convert(inaira)+" Naira";
            if(ikobo>0){
                words += (", "+convert(ikobo)+" Kobo");
            }else{
                words += (", Zero Kobo");
            }
            
        }catch(Exception ks){
        }
        return words;
    }

    public static void main(final String[] args) {
        final Random generator = new Random();
        ConvertNumberToWord convert = new ConvertNumberToWord();
        System.out.println(convert.convertAmount(5000.));
        int n;
        for (int i = 0; i < 20; i++) {
            n = generator.nextInt(Integer.MAX_VALUE);

            System.out.printf("%10d = '%s'%n", n, convert.convert(n));
        }

        n = 1000;
        System.out.printf("%10d = '%s'%n", n, convert.convert(n));

        n = 2000;
        System.out.printf("%10d = '%s'%n", n, convert.convert(n));

        n = 10000;
        System.out.printf("%10d = '%s'%n", n, convert.convert(n));

        n = 0;
        System.out.printf("%10d = '%s'%n", n, convert.convert(n));

        n = 999999999;
        System.out.printf("%10d = '%s'%n", n, convert.convert(n));

        n = Integer.MAX_VALUE;
        System.out.printf("%10d = '%s'%n", n, convert.convert(n));
    }
}
