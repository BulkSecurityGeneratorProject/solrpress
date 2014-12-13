package com.dynamicguy.app.web.rest;

import com.codahale.metrics.annotation.Timed;
import com.dynamicguy.app.domain.Keyword;
import com.dynamicguy.app.repository.KeywordRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.inject.Inject;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

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
    public void create(@RequestBody Keyword keyword) {
        log.debug("REST request to save Keyword : {}", keyword);
        keywordRepository.save(keyword);
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
    public ResponseEntity<Keyword> get(@PathVariable String id, HttpServletResponse response) {
        log.debug("REST request to get Keyword : {}", id);
        Keyword keyword = keywordRepository.findOne(id);
        if (keyword == null) {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
        return new ResponseEntity<>(keyword, HttpStatus.OK);
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
