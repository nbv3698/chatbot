package vn.chatbot.validator;

import static java.lang.annotation.ElementType.FIELD;
import static java.lang.annotation.ElementType.METHOD;
import static java.lang.annotation.RetentionPolicy.RUNTIME;

import java.lang.annotation.Documented;
import java.lang.annotation.Retention;
import java.lang.annotation.Target;

import javax.validation.Constraint;
import javax.validation.Payload;

@Target({ METHOD, FIELD })
@Retention(RUNTIME)
@Constraint(validatedBy = MemberExistsValidator.class)
@Documented
public @interface MemberExists {
	String message() default "{MemberExists}";

	Class<?> entity();

	String field();

	Class<?>[] groups() default {};

	Class<? extends Payload>[] payload() default {};
}

