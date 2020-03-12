package com.example.giveandtake.model.entity;

import com.fasterxml.jackson.annotation.JsonIgnore;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import javax.persistence.*;

@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Getter
@Entity
@Table(name = "files")
public class BoardFile {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long fid;
    private String uuid;
    private String uploadPath;
    private String fileName;
    private Boolean image;

    @ManyToOne
    @JoinColumn(name = "board_bid")
    private Board board;

    @OneToOne
    @JoinColumn(name = "user_id")
    private User user;

    @Builder
    public BoardFile(Long fid, String uuid, String uploadPath, String fileName, Boolean image, Board board, User user){
        this.fid = fid;
        this.uuid = uuid;
        this.uploadPath = uploadPath;
        this.fileName = fileName;
        this.image = image;
        this.board = board;
        this.user =user;
    }
}
