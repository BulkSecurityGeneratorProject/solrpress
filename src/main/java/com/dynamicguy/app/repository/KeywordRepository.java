package com.dynamicguy.app.repository;

import com.dynamicguy.app.domain.Keyword;
import org.springframework.data.mongodb.repository.MongoRepository;

/**
 * Spring Data MongoDB repository for the Keyword entity.
 */
public interface KeywordRepository extends MongoRepository<Keyword,String>{

}
