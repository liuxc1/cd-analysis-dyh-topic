package ths.project.common.component;

import org.springframework.context.ApplicationEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.event.ContextClosedEvent;
import org.springframework.context.event.ContextRefreshedEvent;
import org.springframework.stereotype.Component;
import ths.project.common.uid.UniqueIdGenerator;
import ths.project.common.util.UUIDUtil;

@Component
public class UniqueIdGeneratorApplicationListener implements ApplicationListener<ApplicationEvent> {

    @Override
    public void onApplicationEvent(ApplicationEvent applicationEvent) {
        if (applicationEvent instanceof ContextRefreshedEvent) {
            UniqueIdGenerator idGenerator = ((ContextRefreshedEvent) applicationEvent).getApplicationContext().getBean(UniqueIdGenerator.class);
            UUIDUtil.addIdGenerator(idGenerator);
        } else if (applicationEvent instanceof ContextClosedEvent) {
            UUIDUtil.removeIdGenerator();
        }
    }
}
