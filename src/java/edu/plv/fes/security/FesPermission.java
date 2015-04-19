package edu.plv.fes.security;

import edu.plv.fes.constants.FESConstants;
import org.apache.commons.lang.StringUtils;
import org.apache.shiro.authz.Permission;
import org.apache.shiro.util.CollectionUtils;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

/**
 * Created by NazIsEvil on 1/13/2015.
 */
public class FesPermission implements Permission, Serializable {
    // Permission Constants
    protected static final String WILDCARD_TOKEN = "*";
    protected static final String PART_DIVIDER_TOKEN = ":";
    protected static final String SUBPART_DIVIDER_TOKEN = ",";
    protected static final boolean DEFAULT_CASE_SENSITIVE = false;

    private List<Set<String>> parts;

    protected FesPermission() {
    }

    public FesPermission(String wildcardString) {
        this(wildcardString, DEFAULT_CASE_SENSITIVE);
    }

    public FesPermission(String wildcardString, boolean caseSensitive) {
        setParts(wildcardString, caseSensitive);
    }

    protected void setParts(String wildcardString) {
        setParts(wildcardString, DEFAULT_CASE_SENSITIVE);
    }
    protected void setParts(String wildcardString, boolean caseSensitive) {
        if (wildcardString == null || wildcardString.trim().length() == 0) {
            throw new IllegalArgumentException("Wildcard string cannot be null or empty. Make sure permission strings are properly formatted.");
        }

        wildcardString = wildcardString.trim();

        List<String> parts = CollectionUtils.asList(wildcardString.split(PART_DIVIDER_TOKEN));

        this.parts = new ArrayList<Set<String>>();
        for (String part : parts) {
            Set<String> subparts = CollectionUtils.asSet(part.split(SUBPART_DIVIDER_TOKEN));
            if (!caseSensitive) {
                subparts = lowercase(subparts);
            }
            if (subparts.isEmpty()) {
                throw new IllegalArgumentException("Wildcard string cannot contain parts with only dividers. Make sure permission strings are properly formatted.");
            }
            this.parts.add(subparts);
        }

        if (this.parts.isEmpty()) {
            throw new IllegalArgumentException("Wildcard string cannot contain only dividers. Make sure permission strings are properly formatted.");
        }
    }
    private Set<String> lowercase(Set<String> subparts) {
        Set<String> lowerCasedSubparts = new LinkedHashSet<String>(subparts.size());
        for (String subpart : subparts) {
            String finalName = stripActionName(subpart);
            if(finalName != null)
            {
                lowerCasedSubparts.add(finalName.toLowerCase());
            }
        }
        return lowerCasedSubparts;
    }
    private String stripActionName(String action) {
        if( StringUtils.startsWith(action, FESConstants.ROLE_VIEW_PREFIX) ) {
            return FESConstants.ROLE_VIEW_PREFIX;
        }
        if( StringUtils.startsWith(action,FESConstants.ROLE_EDIT_PREFIX) ) {
            return FESConstants.ROLE_EDIT_PREFIX;
        }
        if( StringUtils.startsWith(action,FESConstants.ROLE_ADD_PREFIX) ) {
            return FESConstants.ROLE_ADD_PREFIX;
        }
        return action;
    }
    protected List<Set<String>> getParts() {
        return this.parts;
    }

    public boolean implies(Permission p) {
        if (!(p instanceof FesPermission)) {
            return false;
        }

        FesPermission wp = (FesPermission) p;

        List<Set<String>> otherParts = wp.getParts();

        int i = 0;
        for (Set<String> otherPart : otherParts) {
            if (getParts().size() - 1 < i) {
                return true;
            } else {
                Set<String> part = getParts().get(i);
                if (!part.contains(WILDCARD_TOKEN) && !part.containsAll(otherPart)) {
                    return false;
                }
                i++;
            }
        }

        for (; i < getParts().size(); i++) {
            Set<String> part = getParts().get(i);
            if (!part.contains(WILDCARD_TOKEN)) {
                return false;
            }
        }

        return true;
    }
    public String toString() {
        StringBuilder buffer = new StringBuilder();
        for (Set<String> part : parts) {
            if (buffer.length() > 0) {
                buffer.append(":");
            }
            buffer.append(part);
        }
        return buffer.toString();
    }
    public boolean equals(Object o) {
        if (o instanceof FesPermission) {
            FesPermission wp = (FesPermission) o;
            return parts.equals(wp.parts);
        }
        return false;
    }

    public int hashCode() {
        return parts.hashCode();
    }

}
