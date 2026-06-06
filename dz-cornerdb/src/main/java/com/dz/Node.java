package com.dz;

public class Node {
    private int index;
    private byte depth;
    private String last;

    public Node(int index, byte depth, String last){
        this.index = index;
        this.depth = depth;
        this.last = last;
    }

    public int getIndex() {
        return index;
    }

    public byte getDepth() {
        return depth;
    }

    public String getLast() {
        return last;
    }
}
