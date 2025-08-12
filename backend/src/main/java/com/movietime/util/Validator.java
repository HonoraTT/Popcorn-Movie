package com.movietime.util;

public class Validator {
    public static boolean checkPassword(String password) {
        // 密码至少6位，包含字母和数字
        if (password == null || password.length() < 6) {
            return false;
        }
        // 检查是否包含字母和数字
        boolean hasLetter = password.matches(".*[a-zA-Z].*");
        boolean hasDigit = password.matches(".*\\d.*");
        return hasLetter && hasDigit;
    }

    public static boolean checkName(String name) {
        // 支持中英文姓名
        if (name == null || name.trim().isEmpty()) {
            return false;
        }
        // 中文：1-5个中文字符，英文：1-20个字母+空格+连字符+撇号
        return name.matches("^[\u4E00-\u9FA5]{1,5}$|^[a-zA-Z\\s\\-']{1,20}$");
    }

    public static boolean checkEmail(String email) {
        // 支持更常见的邮箱格式，包括数字
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        return email.matches("^[a-zA-Z0-9_\\-\\.]+@[a-zA-Z0-9_\\-\\.]+\\.[a-zA-Z]{2,}$");
    }
}
