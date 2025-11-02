// Rate limiting disabled: export no-op middleware so routes won't return 429
// If you want to re-enable rate limiting later, replace these with express-rate-limit
// configuration as before.

export const authLimiter = (req, res, next) => {
    // no-op: allow all requests
    next();
};

export const apiLimiter = (req, res, next) => {
    // no-op: allow all requests
    next();
};