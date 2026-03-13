/* Precondition:
 * - 0 <= n <= INT_MAX.
 * - 0 <= key <= 255.
 * - If n > 0, buf is non-null and points to the first element of a contiguous array of at least n valid unsigned char objects, properly aligned for unsigned char, and the storage remains alive for the entire call.
 * - The function reads from buf[0, n).
 * - The function writes to buf[0, n).
 * - The caller holds exclusive read-write ownership of buf[0, n) for the duration of the call.
 * - Let `buf_values_at_entry` denote the sequence of unsigned char values stored in buf[0, n) at function entry.
 */
unsigned char xor_mask_and_checksum(unsigned char* buf, int n, unsigned char key) {
    unsigned int sum = 0;

    /* Invariant:
     * - At loop head: 0 <= i <= n.
     * - There exist `pref` and `suf` such that `buf_values_at_entry = pref ++ suf` and `length(pref) = i`.
     * - The current contents of `buf` over `[0, i)` equal the sequence obtained by XOR-ing each element of `pref` with `key`.
     * - The current contents of `buf` over `[i, n)` equal `suf`.
     * - `sum` equals the sum mod 256 of the elements of the sequence obtained by XOR-ing each element of `pref` with `key`.
     */
    for (int i = 0; i < n; ++i) {
        unsigned char masked = static_cast<unsigned char>(buf[i] ^ key);
        buf[i] = masked;
        sum = (sum + static_cast<unsigned int>(masked)) & 255u;
    }

    /* Postcondition:
     * - Let `buf_values_at_exit` denote the sequence in buf[0, n) on normal return.
     * - The return value equals the sum mod 256 of the elements of `buf_values_at_exit`.
     * - Output segment `[0, n)`: `buf_values_at_exit` equals the sequence obtained by XOR-ing each element of `buf_values_at_entry` with `key`.
     * - All memory not described above is unchanged.
     * - No exception can propagate out of this function.
     */
    return static_cast<unsigned char>(sum);
}