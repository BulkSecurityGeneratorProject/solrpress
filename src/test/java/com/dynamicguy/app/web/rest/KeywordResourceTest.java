package com.dynamicguy.app.web.rest;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.http.MediaType;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import javax.annotation.PostConstruct;
import javax.inject.Inject;
import org.joda.time.LocalDate;
import java.util.List;

import com.dynamicguy.app.Application;
import com.dynamicguy.app.domain.Keyword;
import com.dynamicguy.app.repository.KeywordRepository;

import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

/**
 * Test class for the KeywordResource REST controller.
 *
 * @see KeywordResource
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = Application.class)
@WebAppConfiguration
public class KeywordResourceTest {

    private static final String DEFAULT_TITLE = "SAMPLE_TEXT";
    private static final String UPDATED_TITLE = "UPDATED_TEXT";
    private static final String DEFAULT_DESCRIPTION = "SAMPLE_TEXT";
    private static final String UPDATED_DESCRIPTION = "UPDATED_TEXT";

    private static final Boolean DEFAULT_ACTIVE = false;
    private static final Boolean UPDATED_ACTIVE = true;

    private static final LocalDate DEFAULT_CREATED = new LocalDate(0L);
    private static final LocalDate UPDATED_CREATED = new LocalDate();

    private static final LocalDate DEFAULT_UPDATED = new LocalDate(0L);
    private static final LocalDate UPDATED_UPDATED = new LocalDate();

    @Inject
    private KeywordRepository keywordRepository;

    private MockMvc restKeywordMockMvc;

    private Keyword keyword;

    @PostConstruct
    public void setup() {
        MockitoAnnotations.initMocks(this);
        KeywordResource keywordResource = new KeywordResource();
        ReflectionTestUtils.setField(keywordResource, "keywordRepository", keywordRepository);
        this.restKeywordMockMvc = MockMvcBuilders.standaloneSetup(keywordResource).build();
    }

    @Before
    public void initTest() {
        keywordRepository.deleteAll();
        keyword = new Keyword();
        keyword.setTitle(DEFAULT_TITLE);
        keyword.setDescription(DEFAULT_DESCRIPTION);
        keyword.setActive(DEFAULT_ACTIVE);
        keyword.setCreated(DEFAULT_CREATED);
        keyword.setUpdated(DEFAULT_UPDATED);
    }

    @Test
    public void createKeyword() throws Exception {
        // Validate the database is empty
        assertThat(keywordRepository.findAll()).hasSize(0);

        // Create the Keyword
        restKeywordMockMvc.perform(post("/api/keywords")
                .contentType(TestUtil.APPLICATION_JSON_UTF8)
                .content(TestUtil.convertObjectToJsonBytes(keyword)))
                .andExpect(status().isOk());

        // Validate the Keyword in the database
        List<Keyword> keywords = keywordRepository.findAll();
        assertThat(keywords).hasSize(1);
        Keyword testKeyword = keywords.iterator().next();
        assertThat(testKeyword.getTitle()).isEqualTo(DEFAULT_TITLE);
        assertThat(testKeyword.getDescription()).isEqualTo(DEFAULT_DESCRIPTION);
        assertThat(testKeyword.getActive()).isEqualTo(DEFAULT_ACTIVE);
        assertThat(testKeyword.getCreated()).isEqualTo(DEFAULT_CREATED);
        assertThat(testKeyword.getUpdated()).isEqualTo(DEFAULT_UPDATED);
    }

    @Test
    public void getAllKeywords() throws Exception {
        // Initialize the database
        keywordRepository.save(keyword);

        // Get all the keywords
        restKeywordMockMvc.perform(get("/api/keywords"))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.[0].id").value(keyword.getId()))
                .andExpect(jsonPath("$.[0].title").value(DEFAULT_TITLE.toString()))
                .andExpect(jsonPath("$.[0].description").value(DEFAULT_DESCRIPTION.toString()))
                .andExpect(jsonPath("$.[0].active").value(DEFAULT_ACTIVE.booleanValue()))
                .andExpect(jsonPath("$.[0].created").value(DEFAULT_CREATED.toString()))
                .andExpect(jsonPath("$.[0].updated").value(DEFAULT_UPDATED.toString()));
    }

    @Test
    public void getKeyword() throws Exception {
        // Initialize the database
        keywordRepository.save(keyword);

        // Get the keyword
        restKeywordMockMvc.perform(get("/api/keywords/{id}", keyword.getId()))
            .andExpect(status().isOk())
            .andExpect(content().contentType(MediaType.APPLICATION_JSON))
            .andExpect(jsonPath("$.id").value(keyword.getId()))
            .andExpect(jsonPath("$.title").value(DEFAULT_TITLE.toString()))
            .andExpect(jsonPath("$.description").value(DEFAULT_DESCRIPTION.toString()))
            .andExpect(jsonPath("$.active").value(DEFAULT_ACTIVE.booleanValue()))
            .andExpect(jsonPath("$.created").value(DEFAULT_CREATED.toString()))
            .andExpect(jsonPath("$.updated").value(DEFAULT_UPDATED.toString()));
    }

    @Test
    public void getNonExistingKeyword() throws Exception {
        // Get the keyword
        restKeywordMockMvc.perform(get("/api/keywords/{id}", 1L))
                .andExpect(status().isNotFound());
    }

    @Test
    public void updateKeyword() throws Exception {
        // Initialize the database
        keywordRepository.save(keyword);

        // Update the keyword
        keyword.setTitle(UPDATED_TITLE);
        keyword.setDescription(UPDATED_DESCRIPTION);
        keyword.setActive(UPDATED_ACTIVE);
        keyword.setCreated(UPDATED_CREATED);
        keyword.setUpdated(UPDATED_UPDATED);
        restKeywordMockMvc.perform(post("/api/keywords")
                .contentType(TestUtil.APPLICATION_JSON_UTF8)
                .content(TestUtil.convertObjectToJsonBytes(keyword)))
                .andExpect(status().isOk());

        // Validate the Keyword in the database
        List<Keyword> keywords = keywordRepository.findAll();
        assertThat(keywords).hasSize(1);
        Keyword testKeyword = keywords.iterator().next();
        assertThat(testKeyword.getTitle()).isEqualTo(UPDATED_TITLE);
        assertThat(testKeyword.getDescription()).isEqualTo(UPDATED_DESCRIPTION);
        assertThat(testKeyword.getActive()).isEqualTo(UPDATED_ACTIVE);
        assertThat(testKeyword.getCreated()).isEqualTo(UPDATED_CREATED);
        assertThat(testKeyword.getUpdated()).isEqualTo(UPDATED_UPDATED);
    }

    @Test
    public void deleteKeyword() throws Exception {
        // Initialize the database
        keywordRepository.save(keyword);

        // Get the keyword
        restKeywordMockMvc.perform(delete("/api/keywords/{id}", keyword.getId())
                .accept(TestUtil.APPLICATION_JSON_UTF8))
                .andExpect(status().isOk());

        // Validate the database is empty
        List<Keyword> keywords = keywordRepository.findAll();
        assertThat(keywords).hasSize(0);
    }
}
