package com.dynamicguy.solrpress.domain;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.dynamicguy.solrpress.domain.util.CustomLocalDateSerializer;
import com.dynamicguy.solrpress.domain.util.ISO8601LocalDateDeserializer;
import org.joda.time.LocalDate;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.io.Serializable;
import java.math.BigDecimal;

/**
 * A Keyword.
 */
@Document(collection = "T_KEYWORD")
public class Keyword implements Serializable {

    @Id
    private String id;

    @Field("label")
    private String label;

    @Field("keyword")
    private String keyword;

    @Field("score")
    private BigDecimal score;

    @Field("network")
    private String network;

    @JsonSerialize(using = CustomLocalDateSerializer.class)
    @JsonDeserialize(using = ISO8601LocalDateDeserializer.class)
    @Field("timestamp")
    private LocalDate timestamp;

    @Field("info")
    private String info;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public BigDecimal getScore() {
        return score;
    }

    public void setScore(BigDecimal score) {
        this.score = score;
    }

    public String getNetwork() {
        return network;
    }

    public void setNetwork(String network) {
        this.network = network;
    }

    public LocalDate getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDate timestamp) {
        this.timestamp = timestamp;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
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
                ", label='" + label + "'" +
                ", keyword='" + keyword + "'" +
                ", score='" + score + "'" +
                ", network='" + network + "'" +
                ", timestamp='" + timestamp + "'" +
                ", info='" + info + "'" +
                '}';
    }
}
