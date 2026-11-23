package com.t2kmod;

import android.content.Context;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.InputStream;
import java.io.RandomAccessFile;
import java.util.Arrays;

/** On launch, installs the bundled 2026-27 roster into the game's own main OBB. Never throws. */
public final class RosterPatcher {
    static final String OBB = "main.98.com.t2ksports.nba2k20and.obb";
    static final long STOCK_SIZE = 1953173504L;      // original main OBB; new roster is appended here
    static final long TOC_ENTRY = 23880L;            // index entry of roster.iff
    static final long SECTOR_COUNT = 40L;
    static final byte[] STOCK_ENTRY = hex("ae2b13000000000044ae0f4837770400");
    static final byte[] V06_ENTRY = hex("1ca213000000000044ae0f48628d0e00");

    public static void apply(Context context) {
        try {
            File obb = new File(context.getObbDir(), OBB);
            if (!obb.isFile()) return;
            byte[] target = asset(context, "nba2k20mod/toc-entry.bin");
            RandomAccessFile f = new RandomAccessFile(obb, "rw");
            try {
                if (f.length() < STOCK_SIZE) return;
                byte[] current = new byte[16];
                f.seek(TOC_ENTRY);
                f.readFully(current);
                if (Arrays.equals(current, target)) return;            // already installed
                if (!Arrays.equals(current, STOCK_ENTRY) && !Arrays.equals(current, V06_ENTRY)) return; // unknown data: leave it
                byte[] roster = asset(context, "nba2k20mod/roster-2026-27.bin");
                byte[] sectors = asset(context, "nba2k20mod/archive-size.bin");
                f.seek(STOCK_SIZE);
                f.write(roster);
                f.seek(SECTOR_COUNT);
                f.write(sectors);
                f.getFD().sync();
                f.seek(TOC_ENTRY);                                       // switch the game to the new roster last
                f.write(target);
                f.getFD().sync();
            } finally {
                f.close();
            }
        } catch (Throwable ignored) {
            // Never block the game from starting.
        }
    }

    static byte[] asset(Context context, String name) throws Exception {
        InputStream in = context.getAssets().open(name);
        try {
            ByteArrayOutputStream out = new ByteArrayOutputStream();
            byte[] buf = new byte[65536];
            int n;
            while ((n = in.read(buf)) > 0) out.write(buf, 0, n);
            return out.toByteArray();
        } finally {
            in.close();
        }
    }

    static byte[] hex(String s) {
        byte[] b = new byte[s.length() / 2];
        for (int i = 0; i < b.length; i++) b[i] = (byte) Integer.parseInt(s.substring(2 * i, 2 * i + 2), 16);
        return b;
    }
}
