# Font Sources and Download Information

## Required Fonts for Tafasa App

### 1. FF Khallab (Arabic Font)
**Usage**: All Arabic text in the app (categories, meal names, ingredients, preparation steps, buttons, labels)

**Files Needed**:
- `FFKhallab.ttf` (Regular weight)
- `FFKhallab-Bold.ttf` (Bold weight - 700)

**Where to Get**:
- This is a commercial/licensed Arabic font
- Search for "FF Khallab font" or "Khallab font"
- May need to purchase or obtain license from font foundry
- Alternative: Contact font distributors for Arabic fonts

### 2. Graphic School (English Font)
**Usage**: English text, primarily the app name "Tafasa" and English UI elements

**Files Needed**:
- `GraphicSchool.ttf` (Regular weight)
- `GraphicSchool-Bold.ttf` (Bold weight - 700)

**Where to Get**:
- Search for "Graphic School font" on font websites
- May be available on font marketplaces
- Check license terms before use

## Installation Steps

1. **Obtain the font files** (`.ttf` format)

2. **Place them in this directory**: `Flutter/assets/fonts/`
   ```
   Flutter/
   └── assets/
       └── fonts/
           ├── FFKhallab.ttf
           ├── FFKhallab-Bold.ttf
           ├── GraphicSchool.ttf
           └── GraphicSchool-Bold.ttf
   ```

3. **Verify filenames match exactly** (case-sensitive)

4. **Run these commands**:
   ```bash
   flutter pub get
   flutter clean
   flutter run
   ```

## Font Alternatives

If you cannot obtain the specified fonts, you can use alternatives:

### For FF Khallab (Arabic):
- **Tajawal** (Free, Google Fonts)
- **Cairo** (Free, Google Fonts)
- **Almarai** (Free, Google Fonts)
- **IBM Plex Sans Arabic** (Free, Google Fonts)

### For Graphic School (English):
- **Poppins** (Free, Google Fonts)
- **Montserrat** (Free, Google Fonts)
- **Fredoka** (Free, Google Fonts)

To use alternatives, update these files:
1. `pubspec.yaml` - Change font family names
2. `lib/core/theme/app_theme.dart` - Update fontFamily values

## License Reminder

⚠️ **Important**: Always ensure you have the proper license to use fonts in your application, especially for commercial projects. Check font licenses before distribution.

## Testing Without Fonts

The app will run without custom fonts and will fall back to system defaults. You'll see warnings in the console like:
```
Warning: No fonts were found for family 'FFKhallab'
```

This is normal if fonts aren't added yet. The app will still function properly.

## Support

For font-related issues:
1. Verify file names match exactly (case-sensitive)
2. Check files are `.ttf` format
3. Ensure files are in correct directory
4. Run `flutter pub get` after adding fonts
5. Restart the app completely

---

Last Updated: 2025-01-10
