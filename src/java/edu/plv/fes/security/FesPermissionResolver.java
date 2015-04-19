package edu.plv.fes.security;

import org.apache.shiro.authz.Permission;
import org.apache.shiro.authz.permission.PermissionResolver;

/**
 * Created by NazIsEvil on 1/13/2015.
 */
public class FesPermissionResolver implements PermissionResolver {
    public Permission resolvePermission(String permString) {
        return new FesPermission(permString);
    }
}
