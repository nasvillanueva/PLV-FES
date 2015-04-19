package edu.plv.fes.utils;

import edu.plv.fes.constants.FESConstants;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * Created by NazIsEvil on 1/18/2015.
 */
public class RoleParser {
    public static void createPermissionString(Map<String, String> modules, Map<String, String> params, List<String> rights) {
        Set<String> modSets = modules.keySet();

        for (String modName : modSets) {
            StringBuilder buildPerm = new StringBuilder();
            boolean foundRights = false;
            String mod = "moduleNameX" + modName + "X";
            String view = "viewRightsX" + modName + "X";
            String add = "addRightsX" + modName + "X";
            String edit = "editRightsX" + modName + "X";
            String delete = "deleteRightsX" + modName + "X";

            if (params.containsKey(mod))
                buildPerm.append(modName).append(':');

            if (params.containsKey(view)){
                foundRights = true;
                buildPerm.append(FESConstants.ROLE_VIEW_PREFIX).append(',');
            }
            if (params.containsKey(add)){
                foundRights = true;
                buildPerm.append(FESConstants.ROLE_ADD_PREFIX).append(',');
            }
            if (params.containsKey(edit)){
                foundRights = true;
                buildPerm.append(FESConstants.ROLE_EDIT_PREFIX).append(',');
            }
            if (params.containsKey(delete))
            {
                foundRights = true;
                buildPerm.append(FESConstants.ROLE_DELETE_PREFIX).append(',');
            }
            if (foundRights){
                String finalRights = buildPerm.toString();

                finalRights = finalRights.substring(0, finalRights.lastIndexOf(','));
                finalRights += ":*";
                rights.add(finalRights);
            }
        }
    }
}
