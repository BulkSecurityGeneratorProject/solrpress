package com.dynamicguy.solrpress.repository;

import com.dynamicguy.solrpress.domain.Keyword;
import org.springframework.data.mongodb.repository.MongoRepository;

/**
 * Spring Data MongoDB repository for the Keyword entity.
 */
public interface KeywordRepository extends MongoRepository<Keyword,String> {

}
