package ths.project.common.exception;

import ths.jdp.core.exception.ThsException;

public class CtThsException extends ThsException {
    private static final long serialVersionUID = 4073856944445907359L;

    public CtThsException() {
    }

    public CtThsException(String message) {
        super(message);
    }

    public CtThsException(String message, Throwable cause) {
        super(message, cause);
    }

    public CtThsException(Throwable cause) {
        super(cause);
    }
}
