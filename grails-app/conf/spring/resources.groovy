import edu.plv.fes.security.FesPermissionResolver
import org.apache.shiro.authc.credential.HashedCredentialsMatcher

// Place your Spring DSL code here
beans = {
    shiroPermissionResolver(FesPermissionResolver)

    credentialMatcher(HashedCredentialsMatcher) {
        hashAlgorithmName = 'SHA-512'
        storedCredentialsHexEncoded = true
    }
}
