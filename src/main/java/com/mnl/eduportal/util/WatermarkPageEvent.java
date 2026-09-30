/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package com.mnl.eduportal.util;

import com.itextpdf.text.*;
import com.itextpdf.text.pdf.*;
import java.io.InputStream;

public class WatermarkPageEvent extends PdfPageEventHelper {
Settings settings = new Settings();
    @Override
    public void onEndPage(PdfWriter writer, Document document) {
        PdfContentByte canvas = writer.getDirectContentUnder();
        try {
            
                //Image watermark = Image.getInstance(logoStream.readAllBytes());
                Image watermark = Image.getInstance(settings.baseurl + "/" + settings.logo);
                float x = (document.getPageSize().getWidth() - 400) / 2;  // Center horizontally
                float y = (document.getPageSize().getHeight() - 200) / 2; // Center vertically
                watermark.setAbsolutePosition(x, y);
                watermark.scaleToFit(400, 400); // Resize watermark

                PdfGState gState = new PdfGState();
                gState.setFillOpacity(0.2f);  // 30% opacity
                gState.setStrokeOpacity(0.2f);
                canvas.setGState(gState);

                canvas.addImage(watermark);

        

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
