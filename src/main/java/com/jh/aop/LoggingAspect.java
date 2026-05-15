package com.jh.aop;

import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.AfterThrowing;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

/**
 * 서비스 레이어 전반을 감싸는 로깅 Aspect
 * - 메서드 호출 / 반환 / 예외 / 실행 시간을 SLF4J 로 기록한다.
 */
@Aspect
@Component
public class LoggingAspect {

    private static final Logger log = LoggerFactory.getLogger(LoggingAspect.class);

    /** 기존 서비스 + 신규 제안서 서비스 전체 대상 */
    private static final String POINTCUT =
        "execution(* com.jh.service..*(..)) || execution(* com.jh.service.proposal..*(..))";

    @Before(POINTCUT)
    public void logBefore(JoinPoint jp) {
        log.info("[호출] {}.{}()",
            jp.getTarget().getClass().getSimpleName(),
            jp.getSignature().getName());
    }

    @AfterReturning(pointcut = POINTCUT, returning = "result")
    public void logAfterReturning(JoinPoint jp, Object result) {
        log.info("[완료] {}.{}() → {}",
            jp.getTarget().getClass().getSimpleName(),
            jp.getSignature().getName(),
            (result == null ? "void" : result.getClass().getSimpleName()));
    }

    @AfterThrowing(pointcut = POINTCUT, throwing = "ex")
    public void logAfterThrowing(JoinPoint jp, Throwable ex) {
        log.error("[예외] {}.{}() → {}",
            jp.getTarget().getClass().getSimpleName(),
            jp.getSignature().getName(),
            ex.getMessage(), ex);
    }

    /** 실행 시간 측정 (제안서 서비스만) */
    @Around("execution(* com.jh.service.proposal..*(..))")
    public Object logExecutionTime(ProceedingJoinPoint pjp) throws Throwable {
        long start = System.currentTimeMillis();
        try {
            return pjp.proceed();
        } finally {
            long elapsed = System.currentTimeMillis() - start;
            log.debug("[성능] {}.{}() {}ms",
                pjp.getTarget().getClass().getSimpleName(),
                pjp.getSignature().getName(),
                elapsed);
        }
    }
}
