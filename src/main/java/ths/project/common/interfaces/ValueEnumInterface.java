package ths.project.common.interfaces;

public interface ValueEnumInterface<T extends Enum<T> & ValueEnumInterface<T, V>, V> {
    V getValue();

    default boolean equalsValue(V v) {
        return this.getValue().equals(v);
    }
}
