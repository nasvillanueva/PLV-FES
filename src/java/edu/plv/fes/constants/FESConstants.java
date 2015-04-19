package edu.plv.fes.constants;

/**
 * Created by NazIsEvil on 1/13/2015.
 */
public class FESConstants {
    //For Permissions
    public static final String ROLE_ADD_PREFIX = "add";
    public static final String ROLE_EDIT_PREFIX = "edit";
    public static final String ROLE_DELETE_PREFIX = "delete";
    public static final String ROLE_VIEW_PREFIX = "view";

    //usertype
    public static final String USER_TYPE_ADMIN = "Administrator";
    public static final String USER_TYPE_CHAIR = "Chairperson";
    public static final String USER_TYPE_SUPER = "Supervisor";
    public static final String USER_TYPE_STUDENT= "Student";

    //Default Permission for Evaluators (chairperson and student)
    public static final String PERM_STUDENT_EVAL = "evaluation:view,add:*";
    public static final String PERM_STUDENT_LIST = "evaluationList:view:*";

    public static final String PERM_CHAIR_EVAL = "evaluation:view,add,peer:*";
    public static final String PERM_CHAIR_LIST = "evaluationList:view:*";

    public static final String PERM_SUPER_EVAL = "evaluation:view,add,supervisor:*";
    public static final String PERM_SUPER_LIST = "evaluationList:view:*";

    //Decimal Format
    public static final String SCORE_2DECIMAL_FORMAT = "0.00";

}
