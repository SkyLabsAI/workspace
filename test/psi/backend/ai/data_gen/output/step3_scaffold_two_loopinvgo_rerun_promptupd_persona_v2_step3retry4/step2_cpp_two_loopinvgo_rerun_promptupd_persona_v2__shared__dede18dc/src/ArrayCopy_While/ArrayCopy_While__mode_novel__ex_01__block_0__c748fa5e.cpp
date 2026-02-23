/* Precondition:
 * - 0 <= n <= INT_MAX.
 * - INT_MIN <= min_cmd <= INT_MAX.
 * - INT_MIN <= max_cmd <= INT_MAX.
 * - min_cmd <= max_cmd.
 * - If n > 0, cmd is non-null and points to the first element of a contiguous array of at least n valid int objects, properly aligned for int, and the storage remains alive for the entire call.
 * - The function reads from cmd[0, n).
 * - The function writes to cmd[0, n).
 * - The caller holds exclusive read-write ownership of cmd[0, n) for the duration of the call.
 * - Let cmd_values_at_entry denote the sequence of int values stored in cmd[0, n) at function entry.
 */
int saturate_actuator_commands(int cmd[], int n, int min_cmd, int max_cmd) {
    int saturated = 0;
    int i = 0;

    /* Invariant:
     * - At loop head: 0 <= i <= n.
     * - There exist pref and suf such that cmd_values_at_entry = pref ++ suf and length(pref) = i.
     * - The current contents of cmd over [0, i) equal pref with each element replaced by min_cmd if below min_cmd, by max_cmd if above max_cmd, otherwise unchanged.
     * - The current contents of cmd over [i, n) equal suf.
     * - 0 <= saturated <= i.
     * - saturated equals the number of elements of pref that are < min_cmd or > max_cmd.
     */
    for (; i < n; ++i) {
        const int v = cmd[i];
        if (v < min_cmd) {
            cmd[i] = min_cmd;
            saturated++;
        } else if (v > max_cmd) {
            cmd[i] = max_cmd;
            saturated++;
        }
    }

    /* Postcondition:
     * - Let cmd_values_at_exit denote the sequence in cmd[0, n) on normal return.
     * - The return value equals the number of elements of cmd_values_at_entry that are < min_cmd or > max_cmd.
     * - Output segment [0, n): cmd_values_at_exit equals cmd_values_at_entry with each element replaced by min_cmd if below min_cmd, by max_cmd if above max_cmd, otherwise unchanged.
     * - All memory not described above is unchanged.
     * - No exception can propagate out of this function.
     */
    return saturated;
}