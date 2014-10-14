package com.dynamicguy.solrpress.web.rest;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.delete;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import javax.inject.Inject;
import org.joda.time.LocalDate;
import java.math.BigDecimal;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.MockitoAnnotations;
import org.springframework.boot.test.SpringApplicationConfiguration;
import org.springframework.http.MediaType;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.test.context.TestExecutionListeners;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.support.DependencyInjectionTestExecutionListener;
import org.springframework.test.context.support.DirtiesContextTestExecutionListener;
import org.springframework.test.context.transaction.TransactionalTestExecutionListener;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import com.dynamicguy.solrpress.Application;
import com.dynamicguy.solrpress.domain.Book;
import com.dynamicguy.solrpress.repository.BookRepository;

/**
 * Test class for the BookResource REST controller.
 *
 * @see BookResource
 */
@RunWith(SpringJUnit4ClassRunner.class)
@SpringApplicationConfiguration(classes = Application.class)
@WebAppConfiguration
@TestExecutionListeners({ DependencyInjectionTestExecutionListener.class,
    DirtiesContextTestExecutionListener.class,
    TransactionalTestExecutionListener.class })
public class BookResourceTest {
    
    private static final Long DEFAULT_ID = new Long(1L);
    
    private static final String DEFAULT_TITLE = "SAMPLE_TEXT";
    private static final String UPDATED_TITLE = "UPDATED_TEXT";
        
    private static final String DEFAULT_DESCRIPTION = "SAMPLE_TEXT";
    private static final String UPDATED_DESCRIPTION = "UPDATED_TEXT";
        
    private static final LocalDate DEFAULT_PUBLICATION_DATE = new LocalDate(0L);
    private static final LocalDate UPDATED_PUBLICATION_DATE = new LocalDate();
        
    private static final BigDecimal DEFAULT_PRICE = BigDecimal.ZERO;
    private static final BigDecimal UPDATED_PRICE = BigDecimal.ONE;
        
    private static final String DEFAULT_USER = "SAMPLE_TEXT";
    private static final String UPDATED_USER = "UPDATED_TEXT";
        
    @Inject
    private BookRepository bookRepository;

    private MockMvc restBookMockMvc;

    private Book book;

    @Before
    public void setup() {
        MockitoAnnotations.initMocks(this);
        BookResource bookResource = new BookResource();
        ReflectionTestUtils.setField(bookResource, "bookRepository", bookRepository);

        this.restBookMockMvc = MockMvcBuilders.standaloneSetup(bookResource).build();

        book = new Book();
        book.setId(DEFAULT_ID);

        book.setTitle(DEFAULT_TITLE);
        book.setDescription(DEFAULT_DESCRIPTION);
        book.setPublicationDate(DEFAULT_PUBLICATION_DATE);
        book.setPrice(DEFAULT_PRICE);
        book.setUser(DEFAULT_USER);
    }

    @Test
    public void testCRUDBook() throws Exception {

        // Create Book
        restBookMockMvc.perform(post("/app/rest/books")
                .contentType(TestUtil.APPLICATION_JSON_UTF8)
                .content(TestUtil.convertObjectToJsonBytes(book)))
                .andExpect(status().isOk());

        // Read Book
        restBookMockMvc.perform(get("/app/rest/books/{id}", DEFAULT_ID))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(DEFAULT_ID.intValue()))
                .andExpect(jsonPath("$.title").value(DEFAULT_TITLE.toString()))
                .andExpect(jsonPath("$.description").value(DEFAULT_DESCRIPTION.toString()))
                .andExpect(jsonPath("$.publicationDate").value(DEFAULT_PUBLICATION_DATE.toString()))
                .andExpect(jsonPath("$.price").value(DEFAULT_PRICE.doubleValue()))
                .andExpect(jsonPath("$.user").value(DEFAULT_USER.toString()));

        // Update Book
        book.setTitle(UPDATED_TITLE);
        book.setDescription(UPDATED_DESCRIPTION);
        book.setPublicationDate(UPDATED_PUBLICATION_DATE);
        book.setPrice(UPDATED_PRICE);
        book.setUser(UPDATED_USER);

        restBookMockMvc.perform(post("/app/rest/books")
                .contentType(TestUtil.APPLICATION_JSON_UTF8)
                .content(TestUtil.convertObjectToJsonBytes(book)))
                .andExpect(status().isOk());

        // Read updated Book
        restBookMockMvc.perform(get("/app/rest/books/{id}", DEFAULT_ID))
                .andExpect(status().isOk())
                .andExpect(content().contentType(MediaType.APPLICATION_JSON))
                .andExpect(jsonPath("$.id").value(DEFAULT_ID.intValue()))
                .andExpect(jsonPath("$.title").value(UPDATED_TITLE.toString()))
                .andExpect(jsonPath("$.description").value(UPDATED_DESCRIPTION.toString()))
                .andExpect(jsonPath("$.publicationDate").value(UPDATED_PUBLICATION_DATE.toString()))
                .andExpect(jsonPath("$.price").value(UPDATED_PRICE.doubleValue()))
                .andExpect(jsonPath("$.user").value(UPDATED_USER.toString()));

        // Delete Book
        restBookMockMvc.perform(delete("/app/rest/books/{id}", DEFAULT_ID)
                .accept(TestUtil.APPLICATION_JSON_UTF8))
                .andExpect(status().isOk());

        // Read nonexisting Book
        restBookMockMvc.perform(get("/app/rest/books/{id}", DEFAULT_ID)
                .accept(TestUtil.APPLICATION_JSON_UTF8))
                .andExpect(status().isNotFound());

    }
}
