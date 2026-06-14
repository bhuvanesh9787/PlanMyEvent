package com.ems.util;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.qrcode.QRCodeWriter;
import java.nio.file.FileSystems;
import java.nio.file.Files;
import java.nio.file.Path;

public class QRGenerator {

    public static String generateQR(String content, int bookingId, String savePath) {
        try {
            Path dir = FileSystems.getDefault().getPath(savePath);
            if (!Files.exists(dir)) {
                Files.createDirectories(dir);
            }
            QRCodeWriter writer = new QRCodeWriter();
            BitMatrix matrix = writer.encode(content, BarcodeFormat.QR_CODE, 250, 250);
            String fileName = "booking_" + bookingId + ".png";
            Path filePath = dir.resolve(fileName);
            MatrixToImageWriter.writeToPath(matrix, "PNG", filePath);
            return "qrcodes/" + fileName;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}