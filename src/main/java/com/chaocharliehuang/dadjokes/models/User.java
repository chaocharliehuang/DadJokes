package com.chaocharliehuang.dadjokes.models;

import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Table;
import javax.persistence.Transient;
import javax.persistence.JoinColumn;
import javax.validation.constraints.Size;

import org.springframework.format.annotation.DateTimeFormat;

@Entity
@Table(name="users")
public class User {
	
	@Id
	@GeneratedValue
	private Long id;
	
	@Size(min=3, max=255)
	private String username;
	
	@Size(min=8, max=255)
	private String password;
	
	@Transient
	private String passwordConfirmation;
	
	@OneToMany(mappedBy = "creator", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
	private List<Joke> jokesCreated;
	
	@ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
	    name = "followers", 
	    joinColumns = @JoinColumn(name = "user_id"), 
	    inverseJoinColumns = @JoinColumn(name = "following_id")
    )
    private List<User> following;
	
    @ManyToMany(fetch = FetchType.LAZY)
    @JoinTable(
	    name = "followers", 
	    joinColumns = @JoinColumn(name = "following_id"), 
	    inverseJoinColumns = @JoinColumn(name = "user_id")
    )
    private List<User> followers;
    
    @ManyToMany(fetch=FetchType.LAZY)
    @JoinTable(
    		name = "users_likes",
    		joinColumns = @JoinColumn(name = "user_id"),
    		inverseJoinColumns = @JoinColumn(name = "joke_id")
    		)
    private List<Joke> jokesLiked;
    
    @DateTimeFormat(pattern = "MM/dd/yyy HH:mm:ss")
	private Date createdAt;
	
	@DateTimeFormat(pattern = "MM/dd/yyy HH:mm:ss")
	private Date updatedAt;
	
	public User() {};
	
	public User(String username, String password) {
		this.username = username;
		this.password = password;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getPasswordConfirmation() {
		return passwordConfirmation;
	}

	public void setPasswordConfirmation(String passwordConfirmation) {
		this.passwordConfirmation = passwordConfirmation;
	}

	public List<Joke> getJokesCreated() {
		return jokesCreated;
	}

	public void setJokesCreated(List<Joke> jokesCreated) {
		this.jokesCreated = jokesCreated;
	}

	public List<User> getFollowing() {
		return following;
	}

	public void setFollowing(List<User> following) {
		this.following = following;
	}

	public List<User> getFollowers() {
		return followers;
	}

	public void setFollowers(List<User> followers) {
		this.followers = followers;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public Date getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Date updatedAt) {
		this.updatedAt = updatedAt;
	}
	
	@PrePersist
    protected void onCreate() {
		this.setCreatedAt(new Date());
    }

    @PreUpdate
    protected void onUpdate() {
    		this.setCreatedAt(createdAt);
    		this.setUpdatedAt(new Date());
    }

}
