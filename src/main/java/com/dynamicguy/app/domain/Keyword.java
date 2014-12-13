package com.dynamicguy.app.domain;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.dynamicguy.app.domain.util.CustomLocalDateSerializer;
import com.dynamicguy.app.domain.util.ISO8601LocalDateDeserializer;
import org.joda.time.LocalDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.io.Serializable;

/**
 * A Keyword.
 */
@Document(collection = "T_KEYWORD")
public class Keyword implements Serializable {

    @Id
    private String id;

    @Field("title")
    private String title;

    @Field("description")
    private String description;

    @JsonSerialize(using = CustomLocalDateSerializer.class)
    @JsonDeserialize(using = ISO8601LocalDateDeserializer.class)
    @Field("created")
    private LocalDate created;

    @JsonSerialize(using = CustomLocalDateSerializer.class)
    @JsonDeserialize(using = ISO8601LocalDateDeserializer.class)
    @Field("update")
    private LocalDate update;

    @Field("status")
    private Boolean status;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDate getCreated() {
        return created;
    }

    public void setCreated(LocalDate created) {
        this.created = created;
    }

    public LocalDate getUpdate() {
        return update;
    }

    public void setUpdate(LocalDate update) {
        this.update = update;
    }

    public Boolean getStatus() {
        return status;
    }

    public void setStatus(Boolean status) {
        this.status = status;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) {
            return true;
        }
        if (o == null || getClass() != o.getClass()) {
            return false;
        }

        Keyword keyword = (Keyword) o;

        if (id != null ? !id.equals(keyword.id) : keyword.id != null) return false;

        return true;
    }

    @Override
    public int hashCode() {
        return id != null ? id.hashCode() : 0;
    }

    @Override
    public String toString() {
        return "Keyword{" +
                "id=" + id +
                ", title='" + title + "'" +
                ", description='" + description + "'" +
                ", created='" + created + "'" +
                ", update='" + update + "'" +
                ", status='" + status + "'" +
                '}';
    }
}
