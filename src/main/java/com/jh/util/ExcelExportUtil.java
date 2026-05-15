package com.jh.util;

import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.poi.ss.usermodel.BorderStyle;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.HorizontalAlignment;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import com.jh.vo.ProposalVO;
import com.jh.vo.ReviewVO;

/**
 * Apache POI 기반 Excel 출력 유틸리티
 * - 제안서 목록 / 심사 결과 목록 두 가지 시트를 하나의 .xlsx 파일로 생성한다.
 */
public class ExcelExportUtil {

    private static final SimpleDateFormat SDF = new SimpleDateFormat("yyyy-MM-dd");

    private ExcelExportUtil() {}

    /**
     * 제안서 목록 + 심사 결과 목록을 하나의 Workbook 으로 생성하여
     * 지정된 OutputStream 에 쓴다.
     */
    public static void exportPortal(List<ProposalVO>  proposals,
                                    List<ReviewVO>    reviews,
                                    OutputStream      out) throws IOException {

        try (Workbook wb = new XSSFWorkbook()) {
            writeProposalSheet(wb, proposals);
            writeReviewSheet(wb, reviews);
            wb.write(out);
        }
    }

    // ----------------------------------------------------------------

    private static void writeProposalSheet(Workbook wb, List<ProposalVO> proposals) {
        Sheet sheet = wb.createSheet("제안서 목록");

        CellStyle headerStyle = createHeaderStyle(wb);
        CellStyle dataStyle   = createDataStyle(wb);

        String[] headers = {"번호", "제목", "분야", "제안자", "상태", "총점", "마감일", "등록일"};
        Row headerRow = sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            createCell(headerRow, i, headers[i], headerStyle);
        }

        int rowNum = 1;
        for (ProposalVO p : proposals) {
            Row row = sheet.createRow(rowNum++);
            createCell(row, 0, p.getPno(),                             dataStyle);
            createCell(row, 1, p.getTitle(),                           dataStyle);
            createCell(row, 2, p.getCategoryLabel(),                   dataStyle);
            createCell(row, 3, p.getSubmitter(),                       dataStyle);
            createCell(row, 4, p.getStatusLabel(),                     dataStyle);
            createCell(row, 5, p.getTotalScore() != null ? p.getTotalScore().toString() : "-", dataStyle);
            createCell(row, 6, p.getDeadline()  != null ? SDF.format(p.getDeadline())   : "-", dataStyle);
            createCell(row, 7, p.getRegdate()   != null ? SDF.format(p.getRegdate())    : "-", dataStyle);
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
    }

    private static void writeReviewSheet(Workbook wb, List<ReviewVO> reviews) {
        Sheet sheet = wb.createSheet("심사 결과");

        CellStyle headerStyle = createHeaderStyle(wb);
        CellStyle dataStyle   = createDataStyle(wb);

        String[] headers = {"심사번호", "제안서번호", "제안서제목", "심사자", "독창성", "실현가능성", "경제성", "파급효과", "총점", "심사의견", "심사일"};
        Row headerRow = sheet.createRow(0);
        for (int i = 0; i < headers.length; i++) {
            createCell(headerRow, i, headers[i], headerStyle);
        }

        int rowNum = 1;
        for (ReviewVO r : reviews) {
            Row row = sheet.createRow(rowNum++);
            createCell(row, 0,  r.getRno(),           dataStyle);
            createCell(row, 1,  r.getPno(),           dataStyle);
            createCell(row, 2,  r.getProposalTitle() != null ? r.getProposalTitle() : "", dataStyle);
            createCell(row, 3,  r.getReviewerId(),    dataStyle);
            createCell(row, 4,  r.getScoreOriginality(),  dataStyle);
            createCell(row, 5,  r.getScoreFeasibility(),  dataStyle);
            createCell(row, 6,  r.getScoreEconomy(),      dataStyle);
            createCell(row, 7,  r.getScoreImpact(),       dataStyle);
            createCell(row, 8,  r.getTotalScore(),        dataStyle);
            createCell(row, 9,  r.getOpinion() != null ? r.getOpinion() : "", dataStyle);
            createCell(row, 10, r.getReviewDate() != null ? SDF.format(r.getReviewDate()) : "-", dataStyle);
        }

        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }
    }

    // ----------------------------------------------------------------
    // 스타일 헬퍼
    // ----------------------------------------------------------------

    private static CellStyle createHeaderStyle(Workbook wb) {
        CellStyle style = wb.createCellStyle();
        Font font = wb.createFont();
        font.setBold(true);
        font.setColor(IndexedColors.WHITE.getIndex());
        style.setFont(font);
        style.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setAlignment(HorizontalAlignment.CENTER);
        setBorder(style);
        return style;
    }

    private static CellStyle createDataStyle(Workbook wb) {
        CellStyle style = wb.createCellStyle();
        setBorder(style);
        return style;
    }

    private static void setBorder(CellStyle style) {
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
    }

    private static void createCell(Row row, int col, Object value, CellStyle style) {
        Cell cell = row.createCell(col);
        if (value instanceof Integer) {
            cell.setCellValue((Integer) value);
        } else if (value instanceof Double) {
            cell.setCellValue((Double) value);
        } else {
            cell.setCellValue(value != null ? value.toString() : "");
        }
        cell.setCellStyle(style);
    }
}
