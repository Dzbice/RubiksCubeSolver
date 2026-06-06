package com.dz;

import java.util.HashMap;
import java.util.Map;

public class Moves {
  public static final Map<String, int[][]> MOVES_TABLE = new HashMap<>();
  public static final Map<String, String> INVERSE = new HashMap<>();
  public static final Map<String, String> DOUBLE = new HashMap<>();
  public static final Map<String, String> OPPOSITE = new HashMap<>();

  static {
    MOVES_TABLE.put("U", new int[][] {{0, 1, 2, 3}, {8, 9, 10, 11}, {0, 0, 0, 0}, {0, 0, 0, 0}});
    MOVES_TABLE.put("D", new int[][] {{4, 5, 6, 7}, {12, 13, 14, 15}, {0, 0, 0, 0}, {0, 0, 0, 0}});
    MOVES_TABLE.put("F", new int[][] {{3, 2, 6, 7}, {10, 18, 14, 19}, {2, 1, 2, 1}, {1, 1, 1, 1}});
    MOVES_TABLE.put("B", new int[][] {{0, 4, 5, 1}, {8, 16, 12, 17}, {2, 1, 2, 1}, {1, 1, 1, 1}});
    MOVES_TABLE.put("L", new int[][] {{0, 4, 7, 3}, {11, 16, 15, 19}, {1, 2, 1, 2}, {0, 0, 0, 0}});
    MOVES_TABLE.put("R", new int[][] {{1, 5, 6, 2}, {9, 17, 13, 18}, {2, 1, 2, 1}, {0, 0, 0, 0}});

    INVERSE.put("U'", "U");
    INVERSE.put("D'", "D");
    INVERSE.put("F'", "F");
    INVERSE.put("B'", "B");
    INVERSE.put("L'", "L");
    INVERSE.put("R'", "R");

    DOUBLE.put("U2", "U");
    DOUBLE.put("D2", "D");
    DOUBLE.put("F2", "F");
    DOUBLE.put("B2", "B");
    DOUBLE.put("L2", "L");
    DOUBLE.put("R2", "R");

    OPPOSITE.put("R", "L");
    OPPOSITE.put("L", "R");
    OPPOSITE.put("U", "D");
    OPPOSITE.put("D", "U");
    OPPOSITE.put("F", "B");
    OPPOSITE.put("B", "F");
  }

  public static void apply_move(int[] cube, String move) {
    if (cube.length <= 8) {
      cubeieMove(cube, move, 0);
      corner_orient(cube, move);
    } else if (cube.length > 8 && cube.length < 20) {
      cubeieMove(cube, move, 1);
      edge_orient(cube, move);
    } else {
      cubeieMove(cube, move, 0);
      cubeieMove(cube, move, 1);
      edge_orient(cube, move);
      corner_orient(cube, move);
    }
  }

  private static void edge_orient(int[] cube, String move) {
    int[] moved_pieces = MOVES_TABLE.get(move)[1];
    int x = 0;
    for (int i : MOVES_TABLE.get(move)[3]) {
      int piece = cube[moved_pieces[x]];
      cube[moved_pieces[x]] = (piece / 2) * 2 + ((piece % 2 + i) % 2);
      x++;
    }
  }

  private static void cubeieMove(int[] cube, String move, int local) {
    int[] arr = MOVES_TABLE.get(move)[local];
    int tmp = cube[arr[3]];
    for (int i = 2; i >= 0; i--) {
      cube[arr[i + 1]] = cube[arr[i]];
    }
    cube[arr[0]] = tmp;
  }

  private static void corner_orient(int[] cube, String move) {
    int[] moved_pieces = MOVES_TABLE.get(move)[0];
    int x = 0;
    for (int i : MOVES_TABLE.get(move)[2]) {
      int piece = cube[moved_pieces[x]];
      cube[moved_pieces[x]] = (piece / 3) * 3 + ((piece % 3 + i) % 3);
      x++;
    }
  }

  public static void parseMoves(int[] cube, String moves) {
    String[] arr = moves.split(" ");
    for (String move : arr) {
      parse_move(cube, move);
    }
  }

  public static void parse_move(int[] cube, String move) {
    if (move.endsWith("'")) {
      inverse_move(cube, move.split("")[0]);
    } else if (move.endsWith("2")) {
      double_move(cube, move.split("")[0]);
    } else {
      apply_move(cube, move);
    }
  }

  private static void inverse_move(int[] cube, String s) {
    for (int i = 0; i < 3; i++) {
      apply_move(cube, s);
    }
  }

  private static void double_move(int[] cube, String s) {
      for (int i = 0; i < 2; i++) {
          apply_move(cube, s);
      }
  }
}
