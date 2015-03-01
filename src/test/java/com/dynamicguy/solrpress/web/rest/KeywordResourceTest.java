package com.dynamicguy.solrpress.web.rest;

import com.dynamicguy.solrpress.Application;
import com.dynamicguy.solrpress.domain.Keyword;
import com.dynamicguy.solrpress.repository.KeywordRepository;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.IntegrationTest;
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
import java.math.BigDecimal;
import java.util.List;

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
@IntegrationTest
public class KeywordResourceTest {

    private static final String DEFAULT_LABEL = "SAMPLE_TEXT";
    private static final String UPDATED_LABEL = "UPDATED_TEXT";
    private static final String DEFAULT_KEYWORD = "SAMPLE_TEXT";
    private static final String UPDATED_KEYWORD = "UPDATED_TEXT";

    private static final BigDecimal DEFAULT_SCORE = BigDecimal.ZERO;
    private static final BigDecimal UPDATED_SCORE = BigDecimal.ONE;
    private static final String DEFAULT_NETWORK = "SAMPLE_TEXT";
    private static final String UPDATED_NETWORK = "UPDATED_TEXT";

    private static final LocalDate DEFAULT_TIMESTAMP = new LocalDate(0L);
    private static final LocalDate UPDATED_TIMESTAMP = new LocalDate();
    private static final String DEFAULT_INFO = "SAMPLE_TEXT";
    private static final String UPDATED_INFO = "UPDATED_TEXT";

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
        keyword.setLabel(DEFAULT_LABEL);
        keyword.setKeyword(DEFAULT_KEYWORD);
        keyword.setScore(DEFAULT_SCORE);
        keyword.setNetwork(DEFAULT_NETWORK);
        keyword.setTimestamp(DEFAULT_TIMESTAMP);
        keyword.setInfo(DEFAULT_INFO);
    }

    @Test
    public void createKeyword() throws Exception {
        // Validate the database is empty
        assertThat(keywordRepository.findAll()).hasSize(0);

        // Create the Keyword
        restKeywordMockMvc.perform(post("/api/keywords")
                .contentType(TestUtil.APPLICATION_JSON_UTF8)
                .content(TestUtil.convertObjectToJsonBytes(keyword)))
                .andExpect(status().isCreated());

        // Validate the Keyword in the database
        List<Keyword> keywords = keywordRepository.findAll();
        assertThat(keywords).hasSize(1);
        Keyword testKeyword = keywords.iterator().next();
        assertThat(testKeyword.getLabel()).isEqualTo(DEFAULT_LABEL);
        assertThat(testKeyword.getKeyword()).isEqualTo(DEFAULT_KEYWORD);
        assertThat(testKeyword.getScore()).isEqualTo(DEFAULT_SCORE);
        assertThat(testKeyword.getNetwork()).isEqualTo(DEFAULT_NETWORK);
        assertThat(testKeyword.getTimestamp()).isEqualTo(DEFAULT_TIMESTAMP);
        assertThat(testKeyword.getInfo()).isEqualTo(DEFAULT_INFO);
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
                .andExpect(jsonPath("$.[0].label").value(DEFAULT_LABEL.toString()))
                .andExpect(jsonPath("$.[0].keyword").value(DEFAULT_KEYWORD.toString()))
                .andExpect(jsonPath("$.[0].score").value(DEFAULT_SCORE.intValue()))
                .andExpect(jsonPath("$.[0].network").value(DEFAULT_NETWORK.toString()))
                .andExpect(jsonPath("$.[0].timestamp").value(DEFAULT_TIMESTAMP.toString()))
                .andExpect(jsonPath("$.[0].info").value(DEFAULT_INFO.toString()));
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
            .andExpect(jsonPath("$.label").value(DEFAULT_LABEL.toString()))
            .andExpect(jsonPath("$.keyword").value(DEFAULT_KEYWORD.toString()))
            .andExpect(jsonPath("$.score").value(DEFAULT_SCORE.intValue()))
            .andExpect(jsonPath("$.network").value(DEFAULT_NETWORK.toString()))
            .andExpect(jsonPath("$.timestamp").value(DEFAULT_TIMESTAMP.toString()))
            .andExpect(jsonPath("$.info").value(DEFAULT_INFO.toString()));
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
        keyword.setLabel(UPDATED_LABEL);
        keyword.setKeyword(UPDATED_KEYWORD);
        keyword.setScore(UPDATED_SCORE);
        keyword.setNetwork(UPDATED_NETWORK);
        keyword.setTimestamp(UPDATED_TIMESTAMP);
        keyword.setInfo(UPDATED_INFO);
        restKeywordMockMvc.perform(put("/api/keywords")
                .contentType(TestUtil.APPLICATION_JSON_UTF8)
                .content(TestUtil.convertObjectToJsonBytes(keyword)))
                .andExpect(status().isOk());

        // Validate the Keyword in the database
        List<Keyword> keywords = keywordRepository.findAll();
        assertThat(keywords).hasSize(1);
        Keyword testKeyword = keywords.iterator().next();
        assertThat(testKeyword.getLabel()).isEqualTo(UPDATED_LABEL);
        assertThat(testKeyword.getKeyword()).isEqualTo(UPDATED_KEYWORD);
        assertThat(testKeyword.getScore()).isEqualTo(UPDATED_SCORE);
        assertThat(testKeyword.getNetwork()).isEqualTo(UPDATED_NETWORK);
        assertThat(testKeyword.getTimestamp()).isEqualTo(UPDATED_TIMESTAMP);
        assertThat(testKeyword.getInfo()).isEqualTo(UPDATED_INFO);
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
