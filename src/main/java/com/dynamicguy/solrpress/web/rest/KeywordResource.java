package com.dynamicguy.solrpress.web.rest;

import com.codahale.metrics.annotation.Timed;
import com.dynamicguy.solrpress.domain.Keyword;
import com.dynamicguy.solrpress.repository.KeywordRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.inject.Inject;
import java.net.URI;
import java.net.URISyntaxException;
import java.util.List;
import java.util.Optional;

/**
 * REST controller for managing Keyword.
 */
@RestController
@RequestMapping("/api")
public class KeywordResource {

    private final Logger log = LoggerFactory.getLogger(KeywordResource.class);

    @Inject
    private KeywordRepository keywordRepository;

    /**
     * POST  /keywords -> Create a new keyword.
     */
    @RequestMapping(value = "/keywords",
            method = RequestMethod.POST,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @Timed
    public ResponseEntity<Void> create(@RequestBody Keyword keyword) throws URISyntaxException {
        log.debug("REST request to save Keyword : {}", keyword);
        if (keyword.getId() != null) {
            return ResponseEntity.badRequest().header("Failure", "A new keyword cannot already have an ID").build();
        }
        keywordRepository.save(keyword);
        return ResponseEntity.created(new URI("/api/keywords/" + keyword.getId())).build();
    }

    /**
     * PUT  /keywords -> Updates an existing keyword.
     */
    @RequestMapping(value = "/keywords",
        method = RequestMethod.PUT,
        produces = MediaType.APPLICATION_JSON_VALUE)
    @Timed
    public ResponseEntity<Void> update(@RequestBody Keyword keyword) throws URISyntaxException {
        log.debug("REST request to update Keyword : {}", keyword);
        if (keyword.getId() == null) {
            return create(keyword);
        }
        keywordRepository.save(keyword);
        return ResponseEntity.ok().build();
    }

    /**
     * GET  /keywords -> get all the keywords.
     */
    @RequestMapping(value = "/keywords",
            method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @Timed
    public List<Keyword> getAll() {
        log.debug("REST request to get all Keywords");
        return keywordRepository.findAll();
    }

    /**
     * GET  /keywords/:id -> get the "id" keyword.
     */
    @RequestMapping(value = "/keywords/{id}",
            method = RequestMethod.GET,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @Timed
    public ResponseEntity<Keyword> get(@PathVariable String id) {
        log.debug("REST request to get Keyword : {}", id);
        return Optional.ofNullable(keywordRepository.findOne(id))
            .map(keyword -> new ResponseEntity<>(
                keyword,
                HttpStatus.OK))
            .orElse(new ResponseEntity<>(HttpStatus.NOT_FOUND));
    }

    /**
     * DELETE  /keywords/:id -> delete the "id" keyword.
     */
    @RequestMapping(value = "/keywords/{id}",
            method = RequestMethod.DELETE,
            produces = MediaType.APPLICATION_JSON_VALUE)
    @Timed
    public void delete(@PathVariable String id) {
        log.debug("REST request to delete Keyword : {}", id);
        keywordRepository.delete(id);
    }
}
