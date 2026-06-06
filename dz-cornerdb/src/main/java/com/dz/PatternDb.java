package com.dz;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.Queue;

public class PatternDb extends Moves{
    private  int[] BITS;
    private  int[] FACTORIALS;
    private  int[] solvedCube;
    private  byte[] cornerTable;
    private  String[] moves;
    public PatternDb(){
        this.FACTORIALS = new int[]{1,1,2,6,24,120,720,5040,40320};
        this.BITS = makeBITS();
        this.moves = makeMoves();
        this.cornerTable = new byte[88179840];
        Arrays.fill(cornerTable,(byte)-1);
        this.solvedCube = new int[]{0,3,6,9,12,15,18,21};
        this.cornerTable[encode(Arrays.copyOfRange(solvedCube,0,8))] = 0;
    }

    private int[] makeBITS(){
        int[] bits = new int[256];
        for(int i =0; i<256;i++){
            bits[i] = Integer.bitCount(i);
        }
        return bits;
    }

    private String[] makeMoves(){
        String[] baseMoves = new String[]{"R","L","U","D","F","B"};
        String[] moves = new String[18];
        for(int i= 0; i< 6;i++){
            moves[i*3] = baseMoves[i];
            moves[i*3+1] = baseMoves[i] + "'";
            moves[i*3+2] = baseMoves[i] + "2";
        }
        return moves;
    }

    public  void makeDB(){
        int count = 0;
        Queue<Node> queue = new LinkedList<>(); //offer enqueue, poll dequeue
        Node node = new Node(encode(Arrays.copyOfRange(solvedCube,0,8)),(byte) 0,"");
        queue.offer(node);
        while(!queue.isEmpty()){
            node = queue.poll();
            addMoves(queue, node);
            count += 1;
            if(count % 10000 == 0){
                System.out.printf("So far %d | depth is %d | queue size is %d\n", count, node.getDepth(), queue.size());
            }
        }
    }

    private void addMoves(Queue<Node> queue, Node node){
        for(String move: getMoves()){
            if (node.getLast() != null && !node.getLast().isEmpty()) {
                String baseLast = node.getLast().split("")[0];
                String baseMove = move.split("")[0];
                if (baseLast.equals(baseMove)) continue;
                if (OPPOSITE.get(baseMove).equals(baseLast) && baseMove.compareTo(baseLast) > 0) continue;
            }
            int[] newState = decode(node.getIndex());
            parse_move(newState,move);
            int cornerState = encode(newState);
            if(cornerTable[cornerState] != -1){
                continue;
            }
            cornerTable[cornerState] = (byte)(node.getDepth() + 1);
            queue.offer(new Node(cornerState,(byte)(node.getDepth()+1),move));

        }
    }

    public  int cornerLehmer(int[] state){
        int lehmer  = 0;
        int mask = 0;
        for(int i = 0; i<state.length;i++){
            int id = state[i]/3;
            lehmer = lehmer + BITS[~mask& 0xFF & ((1<< id) -1)] * FACTORIALS[7-i];
            mask = mask | (1<<id);
        }
        return lehmer;
    }
    public  int cornerOrientationId(int[] state){
        int total = 0;
        for(int i = 0; i< 7;i++){
            total = total + state[i] % 3 * (int)Math.pow(3,6-i);
        }
        return total;
    }

    public  int encode(int [] state){
        int index = cornerLehmer(state);
        int ori = cornerOrientationId(state);
        return index * 2187 + ori;
    }
    public int[] decode(int state){
        int[] ori = recodeOri(state % 2187 );
        int[] index = decode_lehmer(state/2187);
        int[] decoded = new int[8];
        for(int i =0; i<index.length;i++){
            decoded[i] = index[i] * 3 + ori[i];
        }
        return decoded;
    }
    public int[] decode_lehmer(int index){
        ArrayList<Integer> base = new ArrayList<Integer>(Arrays.asList(0,1,2,3,4,5,6,7));
        int[] decoded = new int[8];
        for(int i = 0; i<8;i++){
            int fact = FACTORIALS[7-i];
            int digit = index/fact;
            index = index % fact;
            decoded[i] = base.get(digit);
            base.remove(digit);
        }
        return decoded;
    }

    public int[] recodeOri(int orientation){
        int[] twist = new int[8];
        int sum = 0;
        for(int i =0 ; i<7;i++){
            int power = (int)Math.pow(3,6-i);
            twist[i] = orientation / power;
            orientation  %= power;
            sum += twist[i];
        }
        twist[7] = (3-sum % 3) % 3;
        return twist;
    }

    public  String[] getMoves() {
        return moves;
    }

    public void save(String path) throws IOException {
        try (FileOutputStream fos = new FileOutputStream(path)) {
            fos.write(cornerTable);
        }
    }

    public void load(String path) throws IOException {
        try (FileInputStream fis = new FileInputStream(path)) {
            cornerTable = fis.readAllBytes();
        }
    }

    public byte[] getCornerTable() {
        return cornerTable;
    }
}