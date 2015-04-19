package edu.plv.fes.utils;
import java.text.Normalizer;
import java.text.Normalizer.Form;

/**
 * Created by NazIsEvil on 1/13/2015.
 */
public class DiacriticsRemover {

    //This is a snippet from drillio.com/en/software/java/remove-accent-diacritic/
    public static String removeAccents(String text) {
        return text == null ? null :
                Normalizer.normalize(text, Form.NFD).replaceAll("\\p{InCombiningDiacriticalMarks}+", "");
    }
}
